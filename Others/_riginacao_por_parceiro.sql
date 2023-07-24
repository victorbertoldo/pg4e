WITH 
conta AS ( 
    SELECT b.cpf, max(a.id_conta) AS id_conta 
    FROM old.analytics_digio.digio_fat_conta AS a 
    INNER JOIN old.analytics_digio.cadastro AS b 
    ON a.id_conta = b.id_conta 
    WHERE id_produto <> 6 
    GROUP BY 1 ), 
ativacao AS ( 
    SELECT id_conta, min(data_hora_transacao) as data_ativacao 
    from old.analytics_digio.transacoes
    where spending <> 0 
    group by 1 ), 
max_proposal_data AS ( 
    SELECT prop.* 
    FROM old.analytics_digio.nac_proposal AS prop 
    INNER JOIN ( 
            SELECT 
                proposal_id, 
                max(ordem_status_etapa) AS max_etapa, 
                max(id) AS max_id 
                FROM old.analytics_digio.nac_proposal 
                GROUP BY 1 
                ) AS mp 
    ON prop.proposal_id = mp.proposal_id 
    AND prop.ordem_status_etapa = mp.max_etapa 
    AND prop.id = mp.max_id ), 
min_proposal_data AS ( 
    SELECT prop.* 
    FROM old.analytics_digio.nac_proposal AS prop 
    INNER JOIN ( 
            SELECT
                proposal_id, 
                min(ordem_status_etapa) AS min_etapa 
            FROM old.analytics_digio.nac_proposal 
            GROUP BY 1 
            ) AS mp 
    ON prop.proposal_id = mp.proposal_id 
    AND prop.ordem_status_etapa = mp.min_etapa ), 
limite_aprovado AS ( 
    SELECT 
        cpf, 
        p2_approved_total_limit, 
        input_date 
    FROM old.analytics_digio.nac_motor_approval m 
    ), 
proposta AS ( 
    select 
        null as id_produto, 
        cta.id_conta, 
        'nova aquisição' fluxo_aquisicao, 
        prop.proposal_id as id_proposta, 
        prop.referral AS mgm_id, 
        prop.cpf AS cpf, 
        date(prop.input_date) AS datacadastramento, 
        case 
            when maxp.status in ( 'CREDIT_CARD_APPROVED', 'DIGITAL_ACCOUNT_APPROVED', 'REGISTERED_CREDIT_CARD' ) 
                then 'Aprovada' 
            when maxp.status in ('DENIED') 
                then 'Negada' 
            else 'Pendente' 
        end as status_proposta, 
        maxp.status AS StatusProposta, 
        date(maxp.last_updated_date) AS dataaprovacaonegacaopendencia,
        la.p2_approved_total_limit AS limiteglobalcredito, 
        maxp.cp_website_url AS cp_website_url, 
        maxp.cp_source AS cp_source, 
        maxp.cp_medium AS cp_medium, 
        maxp.cp_name AS cp_name, 
        maxp.cp_term AS cp_term, 
        maxp.cp_content AS cp_content, 
        maxp.total_limit AS LimiteGlobalCredito1, 
        maxp.email AS email, 
        maxp.name AS nome 
    FROM min_proposal_data AS prop 
    LEFT JOIN max_proposal_data AS maxp 
    ON prop.proposal_id = maxp.proposal_id 
    LEFT JOIN limite_aprovado AS la 
    ON prop.cpf = la.cpf 
    AND date(prop.input_date) = date(la.input_date) 
    LEFT JOIN conta AS cta ON prop.cpf = cta.cpf 
    WHERE 1 = 1 
    AND prop.cp_source = 'parceiro' 
    AND DATE(prop.input_date) >= date('2021-03-01') ) 
    SELECT 
        case 
            when data_ativacao is not null 
                and dias_ativacao between 0 and 60 
                and StatusProposta = 'Aprovada' 
            then 1 
            else 0 
        end as ativacao, 
        case 
            when dataaprovacaonegacaopendencia is not null 
                and StatusProposta = 'Aprovada' 
            then 1 
            else 0 
        end as aprovacao, 
        case 
            when dias_ativacao between 0 and 30 
                and StatusProposta = 'Aprovada' 
            then 'Ativado até 30 dias' 
            when dias_ativacao between 31 and 60 
                and StatusProposta = 'Aprovada' 
            then 'Ativado de 31 à 60 dias' 
            when dias_ativacao between 61 and 90 
                and StatusProposta = 'Aprovada' 
            then 'Ativado de 61 à 90 dias' 
            when dias_ativacao > 90 
                and StatusProposta = 'Aprovada' 
            then 'Ativado acima de 90 dias' 
            else 'Não ativado' 
        end status_aprovacao, 
        * 
    FROM ( 
            SELECT 
                prop.datacadastramento, 
                datediff( day, prop.datacadastramento, coalesce(ativacao.data_ativacao) ) as dias_ativacao, 
                prop.id_proposta AS cdt_proposal_id, 
                prop.dataaprovacaonegacaopendencia, 
                prop.id_conta, 
                ativacao.data_ativacao, 
                prop.nome, 
                prop.limiteglobalcredito, 
                prop.id_proposta, 
                '' as tipocartao, 
                '' as anudidadecartao, 
                '' as jurosrotativo, 
                prop.status_proposta AS StatusProposta, 
                initcap(regexp_replace(regexp_replace(cp_medium, "[^0-9a-zA-Z_\-]+", ""), "[_-]+", "" "")) AS cp_source, 
                prop.cpf, 
                prop.email 
            FROM proposta AS prop 
            LEFT JOIN ( 
                    SELECT 
                        id_conta, 
                        min(data_hora_transacao) as data_ativacao 
                    from old.analytics_digio.transacoes 
                    where spending <> 0 
                    group by 1 
                    ) ativacao 
            on prop.id_conta = ativacao.id_conta )

select 
 	data_vencimento_padrao as dt_vencimento_fatura,
 	coalesce(count(id_conta), 0) as qtd_faturas,
 	coalesce(sum(valorminimo), 0) as vlr_minimo_fatura,
	coalesce(sum(valortotalfatura), 0) as vlr_total_fatura,
	coalesce(sum(flag_pago), 0) as qtd_pagos,
	coalesce(sum(valores_pagos), 0) as vlr_pagos_fatura,
	coalesce(sum(flag_pago_excedente), 0) as qtd_pagos_excedente,
	coalesce(sum(valores_pagos_excedente), 0) as vlr_pagos_fatura_excedente,
	coalesce(sum(valores_pagos_ate_vcto), 0) as vlr_pagos_ate_vcto,
	coalesce(sum(flag_credito), 0) as qtd_creditos,
	coalesce(sum(valores_credito), 0) as vlr_creditos,
	coalesce(sum(flag_atraso), 0) as qtd_atrasados,
	coalesce(sum(valor_atraso), 0) as vlr_atrasados,
	coalesce(sum(valor_atraso_credor), 0) as vlr_atrasados_credor,
	coalesce(sum(flag_atraso_ant_compulorio), 0) as qtd_atrasados_ant_compulsorio,
	coalesce(sum(valor_atraso_ant_compulorio), 0) as vlr_atrasados_ant_compulsorio,
	coalesce(sum(flag_aberto), 0) as qtd_abertos,
	coalesce(sum(valor_aberto), 0) as vlr_abertos,
	coalesce(sum(flag_pgto_parcial), 0) as qtd_pgto_parciais,
	coalesce(sum(pgto_parcial), 0) as vlr_pgto_parciais,
	coalesce(sum(flag_rotativo), 0) as qtd_rotativos,
	coalesce(sum(valor_pgto_rotativo), 0) as vlr_pgto_rotativo,
	coalesce(sum(sdo_credor), 0) as vlr_rotativo_credor,
	data_adesao_parcelamento as dt_adesao_parcelamento,
	data_processamento_parcelamento as dt_processamento_parcelamento,
	coalesce(sum(flag_parcelamento), 0) as qtd_parcelamento,
	coalesce(sum(valor_total_refin_fatura_parcelamento), 0) as vlr_total_refin_parcelamento,
	coalesce(sum(valor_total_fatura_parcelamento), 0) as vlr_total_parcelamento,
	coalesce(sum(pgto_fatura_parcelamento), 0) as vlr_pgto_parcelamento,
	coalesce(sum(qtd_parc_parcelamento), 0) as qtd_parcelas,
	coalesce(avg(vlr_parc_parcelamento), 0) as vlr_medio_parcelas,
	coalesce(sum(vlr_parc_parcelamento), 0) as vlr_parcelas,
  	coalesce(sum((qtd_parc_parcelamento * valor_total_fatura_parcelamento)), 0) AS pond_prazo_parcelamento,
  	coalesce(sum((tx_parcelamento * valor_total_fatura_parcelamento)), 0) AS tx_media_parcelamento,
	data_adesao_compulsorio,
	data_processamento_compulsorio,
	coalesce(sum(flag_compulsorio), 0) as qtd_compulsorio,
	coalesce(sum(valor_total_refin_fatura_compulsorio), 0) as vlr_total_refin_compulsorio,
	coalesce(sum(valor_total_fatura_compulsorio), 0) as vlr_total_compulsorio,
	coalesce(sum(pgto_fatura_compulsorio), 0) as vlr_pgto_compulsorio,
	coalesce(sum(flag_compulsorio_voluntario), 0) as qtd_compulsorio_voluntario,
	coalesce(sum(valor_fatura_compulsorio_voluntario), 0) as vlr_compulsorio_voluntario,
	coalesce(sum(flag_compulsorio_involuntario), 0) as qtd_compulsorio_involuntario,
	coalesce(sum(valor_fatura_compulsorio_involuntario), 0) as vlr_compulsorio_involuntario,
	coalesce(sum(qtd_parc_compulsorio), 0) as qtd_parcelas_compulsorio,
	coalesce(avg(vlr_parc_compulsorio), 0) as vlr_medio_parcelas_compulsorio,
	coalesce(sum(vlr_parc_compulsorio), 0) as vlr_parcelas_compulsorio,
	coalesce(sum(vlr_entrada_compulsorio), 0) as vlr_entrada_compulsorio,
  	coalesce(sum((qtd_parc_compulsorio * valor_total_fatura_compulsorio)), 0) AS pond_prazo_compulsorio,
  	coalesce(sum((tx_compulsorio * valor_total_fatura_compulsorio)), 0) AS tx_media_compulsorio,
	case 
		when flag_rotativo = 1 then 'ROTATIVO'
		when flag_parcelamento = 1 then 'PARCELAMENTO'
		when flag_compulsorio = 1 then 'COMPULSÓRIO'
		when flag_pago = 1 then 'PAGAMENTO TOTAL'
		when flag_credito = 1 then 'CRÉDITO'
		when flag_aberto = 1 then 'EM ABERTO'
		when flag_atraso = 1 or flag_atraso_ant_compulorio = 1 then 'EM ATRASO'
		else 'OUTROS'
	end as tipo
from (
 	select distinct
		id_conta,
		data_vencimento_padrao,
		data_vencimento_real,
		valorminimo,
		valortotalfatura,
		case when valortotalfatura < 0 then 1 else 0 end as flag_credito,
		case when valortotalfatura < 0 then valortotalfatura else 0 end as valores_credito,
		case when valortotalfatura > 0 and valores_pagos >= valortotalfatura then 1 else 0 end flag_pago,
		case when valortotalfatura > 0 and valores_pagos >= valortotalfatura then valortotalfatura else 0 end as valores_pagos,
		case when valortotalfatura > 0 and valores_pagos > valortotalfatura then 1 else 0 end flag_pago_excedente,
		case when valortotalfatura > 0 and valores_pagos > valortotalfatura then valores_pagos - valortotalfatura else 0 end as valores_pagos_excedente,
		valores_pagos_ate_vcto,
		case when (cast(getdate() as date) > data_vencimento_padrao) and (data_vencimento_padrao > '2023-01-15') and (valortotalfatura > 0 and valores_pagos < valorminimo) and (flag_parcelamento = 0 and flag_compulsorio = 0) then 1 else 0 end flag_atraso,
		case when (cast(getdate() as date) > data_vencimento_padrao) and (data_vencimento_padrao > '2023-01-15') and (valortotalfatura > 0 and valores_pagos < valorminimo) and (flag_parcelamento = 0 and flag_compulsorio = 0) then valores_pagos else 0 end valor_atraso,
		case when (cast(getdate() as date) > data_vencimento_padrao) and (data_vencimento_padrao > '2023-01-15') and (valortotalfatura > 0 and valores_pagos < valorminimo) and (flag_parcelamento = 0 and flag_compulsorio = 0) then valortotalfatura - valores_pagos else 0 end valor_atraso_credor,
		case when (cast(getdate() as date) > data_vencimento_padrao) and (data_vencimento_padrao <= '2023-01-15') and (valortotalfatura > 0 and valores_pagos < valortotalfatura) and (flag_parcelamento = 0 and flag_compulsorio = 0) then 1 else 0 end flag_atraso_ant_compulorio,
		case when (cast(getdate() as date) > data_vencimento_padrao) and (data_vencimento_padrao <= '2023-01-15') and (valortotalfatura > 0 and valores_pagos < valortotalfatura) and (flag_parcelamento = 0 and flag_compulsorio = 0) then valortotalfatura - valores_pagos else 0 end valor_atraso_ant_compulorio,
		case when (cast(getdate() as date) <= data_vencimento_padrao) and (valortotalfatura > 0 and valores_pagos < valorminimo) and (flag_parcelamento = 0 and flag_compulsorio = 0) then 1 else 0 end flag_aberto,
		case when (cast(getdate() as date) <= data_vencimento_padrao) and (valortotalfatura > 0 and valores_pagos < valorminimo) and (flag_parcelamento = 0 and flag_compulsorio = 0) then valortotalfatura - valores_pagos else 0 end valor_aberto,
		flag_pgto_parcial,
		case when flag_pgto_parcial = 1 then valores_pagos else 0 end as pgto_parcial,
		flag_rotativo,
		case when flag_rotativo = 1 then valores_pagos else 0 end as valor_pgto_rotativo,
		case when flag_rotativo = 1 then valortotalfatura - valores_pagos else 0 end as sdo_credor,
		flag_parcelamento,
		case when flag_parcelamento = 1 then valor_total_fatura_parcelamento else 0 end as pgto_fatura_parcelamento,
		data_adesao_parcelamento,
		data_processamento_parcelamento,
		valor_total_refin_fatura_parcelamento,
		valor_total_fatura_parcelamento,
		qtd_parc_parcelamento,
		vlr_parc_parcelamento,
		vlr_entrada_parcelamento,
		tx_parcelamento,
		flag_compulsorio,
		case when flag_compulsorio = 1 then valor_total_fatura_compulsorio else 0 end as pgto_fatura_compulsorio,
		case when flag_compulsorio = 1 and vlr_parc_compulsorio = vlr_entrada_compulsorio then 1 else 0 end as flag_compulsorio_voluntario,
		case when flag_compulsorio = 1 and vlr_parc_compulsorio = vlr_entrada_compulsorio then valor_total_fatura_compulsorio else 0 end as valor_fatura_compulsorio_voluntario,
		case when flag_compulsorio = 1 and vlr_parc_compulsorio <> vlr_entrada_compulsorio then 1 else 0 end as flag_compulsorio_involuntario,
		case when flag_compulsorio = 1 and vlr_parc_compulsorio <> vlr_entrada_compulsorio then valor_total_fatura_compulsorio else 0 end as valor_fatura_compulsorio_involuntario,
		data_adesao_compulsorio,
		data_processamento_compulsorio,
		valor_total_refin_fatura_compulsorio,
		valor_total_fatura_compulsorio,
		qtd_parc_compulsorio,
		vlr_parc_compulsorio,
		vlr_entrada_compulsorio,
		tx_compulsorio
	from (
        select
		    id_conta,
		    datavencimentopadrao_trat as data_vencimento_padrao,
		    datavencimentoreal as data_vencimento_real,
		    valorminimo,
		    valortotalfatura,
		    valores_pagos,
		    valores_pagos_ate_vcto,
				case 
					when valores_pagos < valortotalfatura then 1 
					else 0 
				end as flag_pgto_parcial,
		    case 
		    	when (valores_pagos >= valorminimo)
		    				and (valores_pagos < valortotalfatura)
		    				and (datavencimentopadrao_trat > cast('2023-01-15' as date))
		    				and (id_conta_parcelamento is null) then 1  
		    				else 0 
		    end as flag_rotativo,
		    case 
		    	when id_conta_parcelamento is not null then 1 
		    	else 0 
		    end as flag_parcelamento,
		    data_adesao_parcelamento,
		    data_processamento_parcelamento,
		    valor_total_refin_fatura_parcelamento,
		    valor_total_fatura_parcelamento,
		    qtd_parc_parcelamento,
		    vlr_parc_parcelamento,
		    vlr_entrada_parcelamento,
		    tx_parcelamento,
		    case when id_conta_compulsorio is not null then 1 else 0 end as flag_compulsorio,
		    data_adesao_compulsorio,
		    data_processamento_compulsorio,
		    valor_total_refin_fatura_compulsorio,
		    valor_total_fatura_compulsorio,
		    qtd_parc_compulsorio,
		    vlr_parc_compulsorio,
		    vlr_entrada_compulsorio,
		    tx_compulsorio
		from (
         select
		        jt.*,
		        pdr.id_conta as id_conta_parcelamento,
		        pdr.data_adesao as data_adesao_parcelamento,
		        pdr.data_processamento as data_processamento_parcelamento,
		        pdr.valortotalrefinanciamento as valor_total_refin_fatura_parcelamento,
		        pdr.valortotalfatura as valor_total_fatura_parcelamento,
		        pdr.quantidadeparcelas as qtd_parc_parcelamento,
		        pdr.valorparcela as vlr_parc_parcelamento,
		        pdr.valorentrada as vlr_entrada_parcelamento,
		        pdr.taxarefinanciamento as tx_parcelamento,
		        cmpls.id_conta as id_conta_compulsorio,
		        cmpls.data_adesao as data_adesao_compulsorio,
		        cmpls.data_processamento as data_processamento_compulsorio,
		        cmpls.valortotalrefinanciamento as valor_total_refin_fatura_compulsorio,
		        cmpls.valortotalfatura as valor_total_fatura_compulsorio,
		        cmpls.quantidadeparcelas as qtd_parc_compulsorio,
		        cmpls.valorparcela as vlr_parc_compulsorio,
		        cmpls.valorentrada as vlr_entrada_compulsorio,
		        cmpls.taxarefinanciamento as tx_compulsorio
	        from (
                select
                    jn.id_conta,
                    jn.datavencimentoreal,
                    jn.datavencimentopadrao_trat,
                    jn.inicioperiodofaturado,
                    jn.valorMinimoExtrato as ValorMinimo,
                    jn.SaldoAtualFinal as ValorTotalFatura,
                    jn.financiavelExtrato as financiavelExtrato,
                    jn.numeroCiclo,
                    jn.dt_inicio_faturamento,
                    jn.dt_corte,
                    jn.range_pgto_ini,
                    jn.range_pgto_fim,
                    jn.range_pgto_fat_atual_ini,
                    jn.range_pgto_fat_atual_fim,
                    coalesce(sum(jn.pagamento), 0) as valores_pagos,
                    coalesce(sum(jn.pgto_ate_vencimento), 0) as valores_pagos_ate_vcto
                from (
                    select distinct 
                        hist.id_conta,
                        hist.datavencimentoreal,
                        hist.datavencimentopadrao_trat,
                        hist.valorminimoextrato,
                        hist.numerociclo,
                        hist.pagamentos,
                        hist.saldoatualfinal,
                        hist.datahoraatualizacao,
                        hist.status,
                        hist.totalfuturo,
                        hist.valorminimoextratoanterior,
                        hist.inicioperiodofaturado,
                        hist.financiavelExtrato,
                        hist.dt_inicio_faturamento,
                        hist.dt_corte,
                        hist.range_pgto_ini,
                        hist.range_pgto_fim,
                        hist.range_pgto_fat_atual_ini,
                        hist.range_pgto_fat_atual_fim,
                        sum(pgto.valor_pgto) as valor_pgto,
                        sum( case when pgto.DataOrigem between hist.range_pgto_ini and hist.range_pgto_fim then pgto.valor_pgto end) as pagamento,
                        sum( case when pgto.DataOrigem between hist.range_pgto_fat_atual_ini and hist.range_pgto_fat_atual_fim then pgto.valor_pgto end) as pgto_ate_vencimento
                    from (
                        select
                            id_conta,
                            cast(datavencimentoreal as date) as datavencimentoreal,
                            cast(CONVERT(DATETIME, datavencimentopadrao, 103) as date) as datavencimentopadrao_trat,
                            cast(valorminimoextrato as decimal(15, 2)) as valorminimoextrato,
                            numerociclo,
                            pagamentos,
                            cast(saldoatualfinal as decimal(15, 2)) as saldoatualfinal,
                            datahoraatualizacao,
                            status,
                            cast(totalfuturo as decimal(15, 2)) as totalfuturo,
                            cast(valorminimoextratoanterior as decimal(15, 2)) as valorminimoextratoanterior,
                            inicioperiodofaturado,
                            financiavelExtrato,
                            cast(inicioperiodofaturado as date) as dt_inicio_faturamento,
                            dateadd(MONTH, -1, cast(datahoraatualizacao as date)) as dt_corte,
                            cast(datahoraatualizacao as date) as range_pgto_ini,
                            cast(datafechamentoproxfatura as date) as range_pgto_fim,
                            dateadd(MONTH, -1, cast(datahoraatualizacao as date)) as range_pgto_fat_atual_ini,
                            cast(datavencimentoreal as date) as range_pgto_fat_atual_fim
                        from CBSS..HistoricosCorrentes
                        where
                            --datavencimentoreal >= '2022-11-01'
                        	cast(datavencimentoreal as date) >= dateadd(month, -4, cast(concat(datepart(year, getdate()), '-', datepart(month, getdate()), '-01') as date))
                            and cast(saldoatualfinal as decimal(15, 2)) > 0
                            and status in (0,3, 10)
                        ) hist
                        left join (
                            select
                                trans.id_conta,
                                cast(trans.DataOrigem as date) as DataOrigem,
                                sum(trans.valor) as valor_pgto
                            from CBSS..TransacoesCorrentes trans
                            left join CBSS..TiposTransacoes tipo on trans.id_tipoTransacao = tipo.id_tipoTransacao
                            where
                                tipo.tipoevento = 'CreditoNormal'
                                and tipo.tipotrans = 'Pagamento'
                                --and trans.dataorigem >= '2022-10-01'
                                and cast(trans.dataorigem as date) >= dateadd(month, -5, cast(concat(datepart(year, getdate()), '-', datepart(month, getdate()), '-01') as date))
                            group by
                              trans.id_conta,
                              trans.dataorigem
                        ) pgto on hist.id_conta = pgto.id_conta
                    group by
                      hist.id_conta,
                      hist.datavencimentoreal,
                      hist.datavencimentopadrao_trat,
                      hist.valorminimoextrato,
                      hist.numerociclo,
                      hist.pagamentos,
                      hist.saldoatualfinal,
                      hist.datahoraatualizacao,
                      hist.status,
                      hist.totalfuturo,
                      hist.valorminimoextratoanterior,
                      hist.inicioperiodofaturado,
                      hist.financiavelExtrato,
                      hist.dt_inicio_faturamento,
                      hist.dt_corte,
                      hist.range_pgto_ini,
                      hist.range_pgto_fim,
                      hist.range_pgto_fat_atual_ini,
                      hist.range_pgto_fat_atual_fim
                ) jn
                group by
                  jn.id_conta,
                  jn.datavencimentoreal,
                  jn.datavencimentopadrao_trat,
                  jn.inicioperiodofaturado,
                  jn.valorMinimoExtrato,
                  jn.SaldoAtualFinal,
                  jn.financiavelExtrato,
                  jn.numeroCiclo,
                  jn.dt_inicio_faturamento,
                  jn.dt_corte,
                  jn.range_pgto_ini,
                  jn.range_pgto_fim,
                  jn.range_pgto_fat_atual_ini,
                  jn.range_pgto_fat_atual_fim
            ) jt
	        left join (
	            select
	            	cast(p.datavencimentopadrao as date) as datavencimentopadrao,
	            	cast(p.datainclusao as date) as data_adesao,
	            	cast(p.dataprocessamentoadesao as date) as data_processamento,
	            	se.id_conta,
	            	se.id_servicoelegivel,
	            	se.id_regracampanha,
	            	p.quantidadeparcelas,
	            	cast(p.valortotalfatura as decimal(15,2)) as valortotalfatura,
	            	cast(p.valorparcela as decimal(15,2)) as valorparcela,
	            	cast(p.valorentrada as decimal(15,2)) as valorentrada,
	            	cast(p.valortotalrefinanciamento as decimal(15,2)) as valortotalrefinanciamento,
	            	cast(p.custoefetivototal as decimal(15,2)) as custoefetivototal,
	            	p.valoriof,
	            	p.valortac,
	            	p.taxarefinanciamento,
	            	p.statusadesao
	            from CBSS..W_PARCELAMENTOS p
	            inner join CBSS..W_SERVICOSELEGIVEIS se ON se.id_servicoelegivel = p.id_servicoelegivel
	            where
	            	id_regracampanha > 0
	            	and p.statusadesao = 3
	            	--and p.datavencimentopadrao >= '2022-11-01'
	            	and cast(p.datavencimentopadrao as date) >= dateadd(month, -4, cast(concat(datepart(year, getdate()), '-', datepart(month, getdate()), '-01') as date))
            ) pdr on jt.id_conta = pdr.id_conta and jt.datavencimentopadrao_trat = pdr.datavencimentopadrao
	        left join (
	            select
	            	cast(p.datavencimentopadrao as date) as datavencimentopadrao,
	            	cast(p.datainclusao as date) as data_adesao,
	            	cast(p.dataprocessamentoadesao as date) as data_processamento,
	            	se.id_conta,
	            	se.id_servicoelegivel,
	            	se.id_regracampanha,
	            	p.quantidadeparcelas,
	            	cast(p.valortotalfatura as decimal(15,2)) as valortotalfatura,
	            	cast(p.valorparcela as decimal(15,2)) as valorparcela,
	            	cast(p.valorentrada as decimal(15,2)) as valorentrada,
	            	cast(p.valortotalrefinanciamento as decimal(15,2)) as valortotalrefinanciamento,
	            	cast(p.custoefetivototal as decimal(15,2)) as custoefetivototal,
	            	p.valoriof,
	            	p.valortac,
	            	p.taxarefinanciamento,
	            	p.statusadesao
	            from CBSS..W_PARCELAMENTOS p
	            inner join CBSS..W_SERVICOSELEGIVEIS se ON se.id_servicoelegivel = p.id_servicoelegivel
	            where
	            	id_regracampanha < 0
	            	and p.statusadesao = 3
	            	and p.dataprocessamentoadesao is not null  
	            	and cast(p.datavencimentopadrao as date) >= dateadd(month, -4, cast(concat(datepart(year, getdate()), '-', datepart(month, getdate()), '-01') as date))
            ) cmpls on jt.id_conta = cmpls.id_conta and jt.datavencimentopadrao_trat = cmpls.datavencimentopadrao
        ) join_parcelamento
    ) create_flags_basic
) create_flags
group by 
	data_vencimento_padrao, 
	data_adesao_parcelamento, 
	data_processamento_parcelamento, 
	data_adesao_compulsorio, 
	data_processamento_compulsorio,
	flag_atraso,
	flag_atraso_ant_compulorio,
	flag_rotativo,
	flag_parcelamento,
	flag_compulsorio,
	flag_pago,
	flag_aberto,
	flag_credito
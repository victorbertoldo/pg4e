--professor
truncate table professor cascade;
alter sequence seq_professor_id restart;
insert into professor 
select 
	nextval('seq_professor_id') as id,
	*
from (
	select distinct 
		dtf.professor
	from dataset_trabalho_final dtf
) t;

--materia
truncate table materia cascade;
alter sequence seq_materia_id restart;
insert into materia 
select 
	nextval('seq_materia_id') as id,
	*
from (
	select distinct 
		dtf.materia
	from dataset_trabalho_final dtf
) t;

--aluno
truncate table aluno cascade;
alter sequence seq_aluno_id restart;
insert into aluno 
select 
	nextval('seq_aluno_id') as id,
	*
from (
	select distinct 
		dtf.estudante 
	from dataset_trabalho_final dtf
) t;

--classe
truncate table classe cascade;
alter sequence seq_classe_id restart;
insert into classe 
select 
	nextval('seq_classe_id') as id_classe,
	*
from (
	select distinct 
		p.id_professor,
		m.id_materia ,
		upper(dtf.numclasse) as descricao_classe 
	from dataset_trabalho_final dtf
	join professor p on dtf.professor  = p.nome_professor 
	join materia m on dtf.materia = m.descricao_materia 
) t;

--agrupamento classe
truncate table agrupamento_classe cascade;
alter sequence seq_classe_id restart;
insert into agrupamento_classe 
select 
	c2.id_classe,
	a2.id_aluno 
from classe c2
join dataset_trabalho_final dtf on c2.descricao_classe  = upper(dtf.numclasse)
left join aluno a2 on dtf.estudante = a2.nome_aluno 
;

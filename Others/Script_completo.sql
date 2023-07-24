create sequence seq_professor_id
increment by 1 
minvalue 1 
maxvalue 999999 
start 100;

create table professor(
	id_professor integer primary key not null default nextval('seq_professor_id'), 
	nome_professor text not null
	);

create sequence seq_materia_id
increment by 1 
minvalue 1 
maxvalue 999999 
start 100;

create table materia(
	id_materia integer primary key not null default nextval('seq_materia_id'), 
	descr_materia text not null
	);

create sequence seq_aluno_id
increment by 1 
minvalue 1 
maxvalue 999999 
start 100;

create table aluno(
	id_aluno integer primary key not null default nextval('seq_aluno_id'), 
	nome_aluno text not null
	);

create sequence seq_classe_id
increment by 1 
minvalue 1 
maxvalue 999999 
start 100;

create table classe(
	id_classe integer primary key not null default nextval('seq_classe_id'), 
	id_professor integer not null,
	id_materia integer not null,
	desc_classe text not null,
	constraint professor_id_professor_fk 
	foreign key (id_professor) references professor(id_professor),
	constraint materia_id_materia_fk 
	foreign key (id_materia) references materia(id_materia)
	);

drop table agrup_classe;

create table agrup_classe(
	id_aluno integer not null,
	id_classe integer not null,
	constraint aluno_id_aluno_fk 
	foreign key (id_aluno) references aluno(id_aluno),
	constraint classe_id_classe_fk 
	foreign key (id_classe) references classe(id_classe)
);

truncate table professor cascade;
alter sequence seq_professor_id restart;
insert into professor 
select
	nextval('seq_professor_id') as id,
	*
from (
	select distinct 
		fde.professor
	from fonte_dados_escola fde
)t;

truncate table materia cascade;
alter sequence seq_materia_id restart;
insert into materia 
select
	nextval('seq_materia_id') as id,
	*
from (
	select distinct 
		fde.materia
	from fonte_dados_escola fde
)t;

truncate table aluno cascade;
alter sequence seq_aluno_id restart;
insert into aluno 
select
	nextval('seq_aluno_id') as id,
	*
from (
	select distinct 
		fde.estudante
	from fonte_dados_escola fde
)t;

truncate table classe cascade;
alter sequence seq_classe_id restart;
insert into classe 
select
	nextval('seq_classe_id') as id,
	*
from (
	select distinct 
		p.id_professor,
		m.id_materia,
		upper(fde.numclasse) as descr_classe
	from fonte_dados_escola fde
		join professor p 
			on fde.professor = p.nome_professor
		join materia m 
			on fde.materia = m.descr_materia
)t;

truncate table agrup_classe cascade;
insert into agrup_classe  
select 
	a2.id_aluno,
	c2.id_classe
from classe c2
join fonte_dados_escola fde 
	on c2.desc_classe = upper(fde.numclasse)
join aluno a2
	on fde.estudante = a2.nome_aluno; 

create view view_alunos_materias as 
select 
	a.nome_aluno as nome_do_aluno,
	m.descr_materia as nome_da_materia
from aluno a 
join agrup_classe ac 
	on a.id_aluno = ac.id_aluno 
join classe c 
	on c.id_classe = ac.id_classe 
join materia m 
	on m.id_materia = c.id_materia;

select * from view_alunos_materias;






















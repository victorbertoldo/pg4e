create sequence seq_aluno_id
increment by 1
minvalue 1
maxvalue 9999999
start 100;

create table aluno (
	id_aluno integer primary key not null default nextval('seq_aluno_id'),
	id_disciplina integer,
	nome text not null,
	cpf bigint,
	rg integer,
	celular text,
	telefone text
)

create sequence seq_disciplina_id
increment by 1
minvalue 1
maxvalue 9999999
start 100;

create table disciplina (
	id_disciplina integer primary key not null default nextval('seq_disciplina_id'),
	id_turma integer,
	descricao text not null
)

create sequence seq_turma_id
increment by 1
minvalue 1
maxvalue 9999999
start 100;

create table turma (
	id_turma integer primary key not null default nextval('seq_turma_id'),
	id_aluno integer,
	id_disciplina integer,
	data date
)
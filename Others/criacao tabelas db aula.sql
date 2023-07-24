create database aula;

create table if not exists aluno
(
      matricula integer not null default nextval('seq_matricula'::regclass),
      nome text not null,
      sobrenome text not null,
      email text,
      constraint aluno_pkey primary KEY(matricula)
);

create table if not exists disciplina
(
      id integer not null default nextval('seq_disciplina'::regclass),
      descricao text not null,
      matricula integer not null,
      CONSTRAINT id_disciplina_pk PRIMARY KEY (id),
      CONSTRAINT matricula_fk FOREIGN KEY (matricula) references aluno(matricula)
);


insert into aluno (nome,sobrenome,email) values ('José Carlos','Cordeiro e Silva','jccsilvacordeiro@gmail.com');

insert into disciplina(descricao,matricula) values ('Matemática',1)
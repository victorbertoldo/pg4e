create database aula;

create table if not exists aluno
(
      id_aluno integer not null default nextval('seq_id_aluno'::regclass),
      nome_aluno text not null,
      sobrenome_aluno text not null,
      email text,
      constraint aluno_pkey primary KEY(id_aluno)
);

create table if not exists disciplina
(
      id_disciplina integer not null default nextval('seq_disciplina'::regclass),
      descricao text not null,
      id_aluno integer not null,
      CONSTRAINT id_disciplina_pk PRIMARY KEY (id_disciplina),
      CONSTRAINT id_aluno_fk FOREIGN KEY (id_aluno) references aluno(id_aluno)
);


insert into aluno (nome_aluno,sobrenome_aluno,email) values ('Rubens','Sousa','rubens@gmail.com');

insert into disciplina(descricao,id_aluno) values ('Português',1)
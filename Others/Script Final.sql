-- CONSULTA --

SELECT
	a.nome_aluno as aluno,
	m.desc_materia as materia
FROM
	aluno a
INNER JOIN agrup_classe ac
    ON ac.id_aluno = a.id_aluno 
INNER JOIN classe c  
    ON c.id_classe  = ac.id_classe 
INNER JOIN materia m  
    ON m.id_materia  = c.id_materia;
    
-- CRIANDO VIEW --
   
create materialized view view_aluno_materia
as
SELECT
	a.nome_aluno as aluno,
	m.desc_materia as materia
FROM
	aluno a
INNER JOIN agrup_classe ac
    ON ac.id_aluno = a.id_aluno 
INNER JOIN classe c  
    ON c.id_classe  = ac.id_classe 
INNER JOIN materia m  
    ON m.id_materia  = c.id_materia
with no data;

-- CARREGANDO DADOS --

refresh materialized view view_aluno_materia;

-- CONSULTANDO A VIEW --

select * from view_aluno_materia;
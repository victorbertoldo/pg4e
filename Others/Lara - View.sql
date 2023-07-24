CREATE RECURSIVE VIEW view_aluno_materia (aluno, materia) AS  select 
	a.nome_aluno,
	m.descricao_materia 
from agrupamento_classe ac
join aluno a on ac.id_aluno  = a.id_aluno 
join classe c on ac.id_classe = c.id_classe  
join materia m on c.id_materia = m.id_materia
order by a.nome_aluno, m.descricao_materia;

SELECT * FROM view_aluno_materia;
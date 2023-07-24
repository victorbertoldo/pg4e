select 
	--ac.*,
	--c.*,
	m.nome_materia,
	a.nome_aluno
from agrup_classe ac
join classe c
	on ac.id_classe = c.id_classe
join materia m
	on c.id_materia = m.id_materia
join aluno a
	on ac.id_aluno = a.id_aluno

	
	
create view alunoMateria as

select 
	--ac.*,
	--c.*,
	m.nome_materia,
	a.nome_aluno
from agrup_classe ac
join classe c
	on ac.id_classe = c.id_classe
join materia m
	on c.id_materia = m.id_materia
join aluno a
	on ac.id_aluno = a.id_aluno


select * from alunomateria;

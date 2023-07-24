select 
	a.nome_aluno as "Aluno",
	m.desc_materia as "Disciplina"
from aluno a 
	inner join agrup_classe ac 
	on ac.id_aluno = a.id_aluno 
	inner join classe c 
	on c.id_classe = ac.id_classe 
	inner join materia m 
	on m.id_materia = c.id_materia 

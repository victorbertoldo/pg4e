create view aluno_materia_view as
select
	e.nome_estudante,
	m.nome_materia
from historico_classe hc
	join classe c
		on c.id_classe = hc.fk_id_classe
	join estudante e
		on e.id_estudante = hc.fk_id_estudante
	join materia m
		on m.id_materia = c.fk_id_materia
	join historico_materia hm
		on hm.fk_id_materia = m.id_materia
	join professor p
		on p.id_professor = hm.fk_id_professor
order by e.nome_estudante;

select * from aluno_materia_view;
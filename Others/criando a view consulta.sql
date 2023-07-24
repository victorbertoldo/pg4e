create view consultaFinalView as 
select a.nome_aluno, m.desc_materia  from agrupamento_classe as ac,materia as m, classe as c, aluno as a
where ac.id_classe = c.id_classe and c.id_materia = m.id_materia 
order by a.nome_aluno;


#visualizar view
SELECT nome_aluno, desc_materia
FROM public.consultafinalview;


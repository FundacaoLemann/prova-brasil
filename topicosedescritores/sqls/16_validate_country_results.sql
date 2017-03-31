SELECT id_serie,
	id_disciplina,
	id_descritor,
	SUM(itens_aplicados),
    SUM(acertos),
    (SUM(acertos) / SUM(itens_aplicados))
FROM provabrasil_topics.desempenho_escola_descritor
GROUP BY id_serie, id_disciplina, id_descritor
ORDER BY id_serie, id_disciplina, id_descritor;
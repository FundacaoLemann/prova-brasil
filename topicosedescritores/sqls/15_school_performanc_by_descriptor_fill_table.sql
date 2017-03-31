INSERT INTO provabrasil_topics.desempenho_escola_descritor
SELECT  id_escola,
        id_serie,
        id_disciplina,
        id_descritor,
        count(*),
        sum(acerto)
FROM respostas
GROUP by id_escola,
        id_serie,
        id_disciplina,
        id_descritor;
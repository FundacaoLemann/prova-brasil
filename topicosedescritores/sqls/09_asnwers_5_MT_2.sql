-- Matemática, 5o ano, bloco 2

INSERT INTO provabrasil_topics.respostas
SELECT
    a.ID_ALUNO,
    i.ID_ITEM,
    a.ID_ESCOLA,
    i.ID_SERIE,
    IF(DISCIPLINA = 'LP', 1, 2),
    i.DESCRITOR,
    SUBSTRING(a.TX_RESP_BLOCO_2_MT, i.ID_POSICAO, 1),
    i.GABARITO,
    SUBSTRING(a.TX_RESP_BLOCO_2_MT, i.ID_POSICAO, 1) = i.GABARITO
FROM provabrasil_topics.alunos_5ef AS a
INNER JOIN provabrasil_topics.itens AS i
    ON i.ID_BLOCO = a.ID_BLOCO_2
    AND i.DISCIPLINA = 'MT'
    AND i.ID_SERIE = 5;
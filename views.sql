CREATE VIEW Comments_withUpvotes AS
SELECT
    c.id AS comentario_id,
    c.title AS titulo,
    c.content AS descricao,
    c._date AS data_criacao,
    COUNT(u.user_id) AS nr_upvotes
FROM
    Comment c
LEFT JOIN
    upvoted u ON c.id = u.comment_id
GROUP BY
    c.id, c.title, c.content, c._date;

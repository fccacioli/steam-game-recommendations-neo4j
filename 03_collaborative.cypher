// Raccomandazione collaborative: "chi raccomanda X raccomanda anche Y".
// Basata sul comportamento degli utenti. Con il campione di 10.000
// recensioni la sovrapposizione tra utenti e' ridotta (limite noto).

MATCH (g1:Game {title: 'Stardew Valley'})<-[:RECOMMENDS]-(u:User)-[:RECOMMENDS]->(g2:Game)
WHERE g1 <> g2
RETURN g2.title AS consigliato, count(DISTINCT u) AS utenti_in_comune
ORDER BY utenti_in_comune DESC
LIMIT 10;

// Analisi descrittive sul grafo.

// --- Tag piu' diffusi nel catalogo ---
MATCH (g:Game)-[:HAS_TAG]->(t:Tag)
RETURN t.name AS tag, count(g) AS num_giochi
ORDER BY num_giochi DESC
LIMIT 15;

// --- Giochi piu' raccomandati (nel campione) ---
MATCH (u:User)-[r:RECOMMENDS]->(g:Game)
WHERE r.is_recommended = true
RETURN g.title AS gioco, count(r) AS raccomandazioni
ORDER BY raccomandazioni DESC
LIMIT 10;

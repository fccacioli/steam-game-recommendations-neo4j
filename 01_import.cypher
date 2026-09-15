// Import dei dati nel grafo.
// File richiesti nella cartella "import" del DBMS:
//   games.csv, games_metadata.json  -> inclusi in questo repo
//   recommendations.csv             -> scaricare da Kaggle (troppo grande per il repo)

// --- Nodi Game da games.csv ---
LOAD CSV WITH HEADERS FROM 'file:///games.csv' AS row
MERGE (g:Game {app_id: toInteger(row.app_id)})
SET g.title          = row.title,
    g.date_release   = date(row.date_release),
    g.rating         = row.rating,
    g.positive_ratio = toInteger(row.positive_ratio),
    g.user_reviews   = toInteger(row.user_reviews),
    g.price_final    = toFloat(row.price_final);

// --- Relazioni (User)-[:RECOMMENDS]->(Game), campione di 10.000 righe ---
// Gli User vengono creati al volo dal campione (non serve importare users.csv).
LOAD CSV WITH HEADERS FROM 'file:///recommendations.csv' AS row
WITH row LIMIT 10000
MERGE (u:User {user_id: toInteger(row.user_id)})
MERGE (g:Game {app_id: toInteger(row.app_id)})
MERGE (u)-[r:RECOMMENDS]->(g)
SET r.is_recommended = (row.is_recommended = 'true'),
    r.hours          = toFloat(row.hours),
    r.helpful        = toInteger(row.helpful),
    r.date           = date(row.date);

// --- Tag da games_metadata.json (richiede il plugin APOC) ---
CALL apoc.load.json('file:///games_metadata.json') YIELD value
WITH value
WHERE value.tags IS NOT NULL AND size(value.tags) > 0
MATCH (g:Game {app_id: toInteger(value.app_id)})
UNWIND value.tags AS tagName
MERGE (t:Tag {name: tagName})
MERGE (g)-[:HAS_TAG]->(t);

// --- Verifica import (conteggio nodi per tipo) ---
MATCH (n)
RETURN labels(n) AS tipo, count(n) AS quantita
ORDER BY quantita DESC;

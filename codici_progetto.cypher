// ============================================================
// Game Recommendations on Steam - Neo4j / Cypher
// Eseguire un blocco alla volta nel Neo4j Browser, in ordine.
// Requisiti: dataset in cartella "import" + plugin APOC.
// ============================================================


// --- STEP 0: vincoli + indici (eseguire per primo) ---
CREATE CONSTRAINT game_id IF NOT EXISTS
FOR (g:Game) REQUIRE g.app_id IS UNIQUE;

CREATE CONSTRAINT user_id IF NOT EXISTS
FOR (u:User) REQUIRE u.user_id IS UNIQUE;

CREATE CONSTRAINT tag_name IF NOT EXISTS
FOR (t:Tag) REQUIRE t.name IS UNIQUE;


// --- STEP 1a: nodi Game da games.csv ---
LOAD CSV WITH HEADERS FROM 'file:///games.csv' AS row
MERGE (g:Game {app_id: toInteger(row.app_id)})
SET g.title          = row.title,
    g.date_release   = date(row.date_release),
    g.rating         = row.rating,
    g.positive_ratio = toInteger(row.positive_ratio),
    g.user_reviews   = toInteger(row.user_reviews),
    g.price_final    = toFloat(row.price_final);


// --- STEP 1b: relazioni (User)-[:RECOMMENDS]->(Game), campione 10k ---
LOAD CSV WITH HEADERS FROM 'file:///recommendations.csv' AS row
WITH row LIMIT 10000
MERGE (u:User {user_id: toInteger(row.user_id)})
MERGE (g:Game {app_id: toInteger(row.app_id)})
MERGE (u)-[r:RECOMMENDS]->(g)
SET r.is_recommended = (row.is_recommended = 'true'),
    r.hours          = toFloat(row.hours),
    r.helpful        = toInteger(row.helpful),
    r.date           = date(row.date);


// --- STEP 2: tag da games_metadata.json (richiede APOC) ---
CALL apoc.load.json('file:///games_metadata.json') YIELD value
WITH value
WHERE value.tags IS NOT NULL AND size(value.tags) > 0
MATCH (g:Game {app_id: toInteger(value.app_id)})
UNWIND value.tags AS tagName
MERGE (t:Tag {name: tagName})
MERGE (g)-[:HAS_TAG]->(t);


// --- STEP 3: verifica import (conteggio nodi per tipo) ---
MATCH (n)
RETURN labels(n) AS tipo, count(n) AS quantita
ORDER BY quantita DESC;


// ============================================================
// Query di analisi
// ============================================================

// --- 4a: tag piu' diffusi ---
MATCH (g:Game)-[:HAS_TAG]->(t:Tag)
RETURN t.name AS tag, count(g) AS num_giochi
ORDER BY num_giochi DESC
LIMIT 15;


// --- 4b: giochi piu' raccomandati ---
MATCH (u:User)-[r:RECOMMENDS]->(g:Game)
WHERE r.is_recommended = true
RETURN g.title AS gioco, count(r) AS raccomandazioni
ORDER BY raccomandazioni DESC
LIMIT 10;


// --- 4c: collaborative filtering (chi raccomanda X raccomanda anche...) ---
MATCH (g1:Game {title: 'Stardew Valley'})<-[:RECOMMENDS]-(u:User)-[:RECOMMENDS]->(g2:Game)
WHERE g1 <> g2
RETURN g2.title AS consigliato, count(DISTINCT u) AS utenti_in_comune
ORDER BY utenti_in_comune DESC
LIMIT 10;


// --- 4d: content-based, similarita' di Jaccard ---
// Jaccard = tag_in_comune / (tag_target + tag_reco - tag_in_comune).
// Ricerca del target con CONTAINS: robusta ai simboli nel titolo (TM, R).
MATCH (target:Game)
WHERE toLower(target.title) CONTAINS 'prince of persia: warrior'
WITH target LIMIT 1
MATCH (target)-[:HAS_TAG]->(t:Tag)<-[:HAS_TAG]-(reco:Game)
WHERE target <> reco
WITH target, reco, count(t) AS comuni
MATCH (target)-[:HAS_TAG]->(tt:Tag)
WITH reco, comuni, count(tt) AS tag_target
MATCH (reco)-[:HAS_TAG]->(rt:Tag)
WITH reco, comuni, tag_target, count(rt) AS tag_reco
RETURN reco.title AS gioco_consigliato,
       comuni,
       round(toFloat(comuni) / (tag_target + tag_reco - comuni), 3) AS similarita_jaccard
ORDER BY similarita_jaccard DESC
LIMIT 10;

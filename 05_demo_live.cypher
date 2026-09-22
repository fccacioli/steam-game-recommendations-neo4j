// Query usate nella demo live (in ordine).

// 1) Il database e' popolato
MATCH (n) RETURN labels(n) AS tipo, count(n) AS quantita ORDER BY quantita DESC;

// 2) 
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
RETURN reco.title AS gioco_consigliato, comuni,
       round(toFloat(comuni)/(tag_target+tag_reco-comuni),3) AS similarita_jaccard
ORDER BY similarita_jaccard DESC LIMIT 10;


//3)
MATCH (g:Game)-[:HAS_TAG]->(t:Tag) RETURN t.name AS tag, count(g) AS numero_giochi ORDER BY numero_giochi DESC LIMIT 10;

//4)
MATCH (target:Game) WHERE toLower(target.title) CONTAINS 'prince of persia: warrior' 
WITH target LIMIT 1 MATCH (target)-[:HAS_TAG]->(t:Tag)<-[:HAS_TAG]-(reco:Game) WHERE target <> reco
AND reco.rating IN ['Very Positive','Overwhelmingly Positive'] WITH target, reco, count(t) AS comuni MATCH (target)-[:HAS_TAG]->(tt:Tag) 
WITH reco, comuni, count(tt) AS tag_target MATCH (reco)-[:HAS_TAG]->(rt:Tag) WITH reco, comuni, tag_target, count(rt) AS tag_reco RETURN reco.title AS gioco, reco.rating AS voto, comuni,   round(toFloat(comuni)/(tag_target+tag_reco-comuni),3) AS jaccard ORDER BY jaccard DESC LIMIT 10;

//5)
MATCH (target:Game) WHERE toLower(target.title) CONTAINS 'prince of persia: warrior' WITH target LIMIT 1 MATCH (target)-[:HAS_TAG]->(t:Tag)<-[:HAS_TAG]-(reco:Game) 
WHERE target <> reco AND reco.date_release >= date('2015-01-01') WITH target, reco, count(t) AS comuni 
MATCH (target)-[:HAS_TAG]->(tt:Tag) WITH reco, comuni, count(tt) AS tag_target MATCH (reco)-[:HAS_TAG]->(rt:Tag) 
WITH reco, comuni, tag_target, count(rt) AS tag_reco RETURN reco.title AS gioco, reco.date_release AS uscita,   round(toFloat(comuni)/(tag_target+tag_reco-comuni),3) AS jaccard ORDER BY jaccard DESC LIMIT 10;

//6)
MATCH (target:Game) WHERE toLower(target.title) CONTAINS 'prince of persia: warrior' WITH target LIMIT 1 MATCH (target)-[:HAS_TAG]->(t:Tag)<-[:HAS_TAG]-(reco:Game) 
WHERE target <> reco WITH target, reco, collect(t.name) AS tag_condivisi, count(t) AS comuni MATCH (target)-[:HAS_TAG]->(tt:Tag) 
WITH reco, tag_condivisi, comuni, count(tt) AS tag_target MATCH (reco)-[:HAS_TAG]->(rt:Tag) 
WITH reco, tag_condivisi, comuni, tag_target, count(rt) AS tag_reco RETURN reco.title AS gioco,   round(toFloat(comuni)/(tag_target+tag_reco-comuni),3) AS jaccard,   tag_condivisi 
ORDER BY jaccard DESC LIMIT 5;

// Query usate nella demo live (in ordine).

// 1) Il database e' popolato
MATCH (n) RETURN labels(n) AS tipo, count(n) AS quantita ORDER BY quantita DESC;

// 2) Motore in azione: giochi simili a Prince of Persia: Warrior Within
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

// 3) Cambio gioco dal vivo (stessa query, altro titolo)
MATCH (target:Game)
WHERE toLower(target.title) CONTAINS 'portal 2'
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

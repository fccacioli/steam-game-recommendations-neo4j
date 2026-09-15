// Motore content-based (cuore del progetto): due giochi sono simili
// se condividono molti tag. Somiglianza misurata con l'indice di Jaccard:
//   Jaccard = tag_in_comune / (tag_target + tag_reco - tag_in_comune)
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

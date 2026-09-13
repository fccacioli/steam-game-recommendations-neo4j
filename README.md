# Steam Game Recommendations con Neo4j

Progetto per il corso di Data Management (2025/2026) - Sapienza.
Fabiano Cacioli (2273170) e Luca Buonomini (2257472).

Abbiamo costruito un piccolo motore di raccomandazione di videogiochi usando Neo4j,
un database a grafo. L'idea di base: due giochi si somigliano se condividono molti tag,
quindi dato un gioco ne consigliamo altri con tag simili (indice di Jaccard).

## Dati

Dataset "Game Recommendations on Steam" da Kaggle:
https://www.kaggle.com/datasets/antonkozyriev/game-recommendations-on-steam

Sono quattro file: games.csv, users.csv, recommendations.csv e games_metadata.json
(quest'ultimo contiene i tag dei giochi).

Nel grafo abbiamo caricato tutti i giochi (~50.000) e i loro tag, e un campione di
10.000 recensioni per la parte sugli utenti.

## Come e' fatto il grafo

Tre tipi di nodo (User, Game, Tag) e due relazioni:
- (User)-[:RECOMMENDS]->(Game)
- (Game)-[:HAS_TAG]->(Tag)

## File

`codici_progetto.cypher` - tutte le query, dall'import alle analisi.
Vanno eseguite un blocco alla volta nel Neo4j Browser, seguendo l'ordine.

## Per farlo girare

Serve Neo4j Desktop con il plugin APOC, e i quattro file del dataset messi nella
cartella "import" del database. Poi si aprono le query e si eseguono dall'alto verso
il basso (prima i vincoli, poi l'import, poi le analisi).

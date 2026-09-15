# Steam Game Recommendations con Neo4j

Progetto per il corso di Data Management (2025/2026) - Sapienza.
Autori: Fabiano Cacioli (2273170) e Luca Buonomini (2257472).
Traccia: [NoSQL] uso di un graph database (Neo4j).

## Di cosa si tratta

Abbiamo costruito un motore di raccomandazione di videogiochi su Neo4j, un database
a grafo. L'idea di base: due giochi si somigliano se condividono molti tag. Dato un
gioco, il sistema ne consiglia altri con tag simili, misurando la somiglianza con
l'indice di Jaccard.

## Il dataset

"Game Recommendations on Steam" (Kaggle):
https://www.kaggle.com/datasets/antonkozyriev/game-recommendations-on-steam

I file:
- `games.csv` - i giochi (incluso nel repo)
- `games_metadata.json` - i tag di ogni gioco (incluso nel repo)
- `recommendations.csv` - le recensioni, milioni di righe (NON incluso: troppo grande,
  scaricabile da Kaggle). Serve solo alla parte collaborative.
- `users.csv` - gli utenti (non usato: gli User vengono creati dal campione di recensioni)

Il motore content-based, che e' il cuore del progetto, usa solo `games.csv` e
`games_metadata.json`: entrambi inclusi qui, quindi la parte principale e'
riproducibile senza scaricare il file grande.

## Modello a grafo

Tre tipi di nodo (User, Game, Tag) e due relazioni:
- (User)-[:RECOMMENDS]->(Game)
- (Game)-[:HAS_TAG]->(Tag)

## Numeri dell'import

- 50.872 giochi
- 441 tag distinti
- 9.990 utenti (dal campione di 10.000 recensioni)

## Un esempio di risultato

Giochi piu' simili a "Prince of Persia: Warrior Within", per indice di Jaccard:

| Gioco consigliato                     | Tag in comune | Jaccard |
|---------------------------------------|:-------------:|:-------:|
| Prince of Persia: The Sands of Time   | 16            | 0.727   |
| Prince of Persia: The Two Thrones     | 14            | 0.636   |
| Darksiders II Deathinitive Edition    | 14            | 0.538   |
| Legacy of Kain: Soul Reaver 2         | 13            | 0.52    |

Il motore ritrova da solo gli altri capitoli della saga, partendo solo dai tag.

## File del progetto

- `00_setup_constraints.cypher` - vincoli e indici (da eseguire per primo)
- `01_import.cypher` - import di giochi, recensioni e tag
- `02_exploration.cypher` - analisi descrittive (tag piu' diffusi, giochi piu' raccomandati)
- `03_collaborative.cypher` - raccomandazione collaborative
- `04_content_based_jaccard.cypher` - il motore content-based con l'indice di Jaccard
- `05_demo_live.cypher` - le query della demo dal vivo

## Come farlo girare

1. Installare Neo4j Desktop e il plugin APOC.
2. Mettere `games.csv` e `games_metadata.json` (e, per la parte collaborative,
   `recommendations.csv` scaricato da Kaggle) nella cartella "import" del database.
3. Eseguire i file Cypher in ordine, un blocco alla volta, nel Neo4j Browser.

## Tecnologie

Neo4j - Cypher - APOC

# Steam Game Recommendations with Neo4j

Data Management course project (2025/2026) - Sapienza University of Rome.
Authors: Fabiano Cacioli (2273170) and Luca Buonomini (2257472).
Project type: [NoSQL] use of a graph database (Neo4j).

## What it is

We built a video game recommendation engine on Neo4j, a graph database. The core idea:
two games are similar if they share many tags. Given a game, the system recommends
others with similar tags, measuring similarity with the Jaccard index.

## The dataset

"Game Recommendations on Steam" (Kaggle):
https://www.kaggle.com/datasets/antonkozyriev/game-recommendations-on-steam

Files:
- `games.csv` - the games (included in this repo)
- `games_metadata.json` - the tags of each game (included in this repo)
- `recommendations.csv` - the reviews, millions of rows (NOT included: too large,
  downloadable from Kaggle). Only needed for the collaborative part.
- `users.csv` - the users (not used: User nodes are created from the reviews sample)

The content-based engine, which is the heart of the project, uses only `games.csv` and
`games_metadata.json`: both included here, so the main feature is reproducible without
downloading the large file.

## Graph model

Three node types (User, Game, Tag) and two relationships:
- (User)-[:RECOMMENDS]->(Game)
- (Game)-[:HAS_TAG]->(Tag)

## Import figures

- 50,872 games
- 441 distinct tags
- 9,990 users (from the sample of 10,000 reviews)

## Sample result

Games most similar to "Prince of Persia: Warrior Within", by Jaccard index:

| Recommended game                      | Shared tags | Jaccard |
|---------------------------------------|:-----------:|:-------:|
| Prince of Persia: The Sands of Time   | 16          | 0.727   |
| Prince of Persia: The Two Thrones     | 14          | 0.636   |
| Darksiders II Deathinitive Edition    | 14          | 0.538   |
| Legacy of Kain: Soul Reaver 2         | 13          | 0.52    |

The engine finds the other chapters of the saga on its own, using only the tags.

## Project files

- `00_setup_constraints.cypher` - constraints and indexes (run first)
- `01_import.cypher` - import of games, reviews and tags
- `02_exploration.cypher` - descriptive analyses (most common tags, most recommended games)
- `03_collaborative.cypher` - collaborative recommendation
- `04_content_based_jaccard.cypher` - the content-based engine with the Jaccard index
- `05_demo_live.cypher` - the live demo queries

## How to run it

1. Install Neo4j Desktop and the APOC plugin.
2. Put `games.csv` and `games_metadata.json` (and, for the collaborative part,
   `recommendations.csv` downloaded from Kaggle) into the database "import" folder.
3. Run the Cypher files in order, one block at a time, in the Neo4j Browser.

## Technologies

Neo4j - Cypher - APOC

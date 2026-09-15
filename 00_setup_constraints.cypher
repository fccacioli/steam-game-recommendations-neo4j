// Step 0 - vincoli e indici (eseguire per primo)
// I CONSTRAINT di unicita' creano anche gli indici usati dalle query.

CREATE CONSTRAINT game_id IF NOT EXISTS
FOR (g:Game) REQUIRE g.app_id IS UNIQUE;

CREATE CONSTRAINT user_id IF NOT EXISTS
FOR (u:User) REQUIRE u.user_id IS UNIQUE;

CREATE CONSTRAINT tag_name IF NOT EXISTS
FOR (t:Tag) REQUIRE t.name IS UNIQUE;

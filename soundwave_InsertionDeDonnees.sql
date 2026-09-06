-- ============================================================
-- SCRIPT D'INSERTION DE DONNEES - PROJET "SOUNDWAVE"
-- ============================================================
-- Auteur : Nicolas
-- Objectif : Insérer un jeu de données de test cohérent et réaliste
--            pour valider la structure et les relations de la base.
-- SGBD utilisé : PostgreSQL
-- Prérequis : le script soundwave_create_final.sql doit avoir été exécuté au préalable
-- ============================================================


-- ------------------------------------------------------------
-- 1) INSERTION DES ARTISTES
-- ------------------------------------------------------------
-- 3 artistes de styles musicaux et pays différents.
INSERT INTO artistes (nom, style_musical, pays) VALUES
('Daft Punk', 'Électro', 'France'),
('Rosalía', 'Flamenco pop', 'Espagne'),
('Stromae', 'Chanson électro', 'Belgique');


-- ------------------------------------------------------------
-- 2) INSERTION DES CONCERTS
-- ------------------------------------------------------------
-- Chaque concert référence un artiste existant (artiste_id).
-- Rosalía anime volontairement 2 concerts, pour tester le comptage
-- de réservations par artiste/concert plus tard.
INSERT INTO concerts (titre, date_heure, lieu, artiste_id) VALUES
('Random Access Tour',              '2026-11-14 20:30:00', 'Zénith de Paris',           1),
('Motomami World Tour',             '2026-12-05 21:00:00', 'AccorHotels Arena, Paris',  2),
('Motomami World Tour - Étape 2',   '2027-01-20 20:00:00', 'Palais Nikaia, Nice',       2),
('Multitude Tour',                  '2026-10-30 20:30:00', 'Zénith de Toulouse',        3);


-- ------------------------------------------------------------
-- 3) INSERTION DES CLIENTS
-- ------------------------------------------------------------
-- 4 clients avec des emails uniques (contrainte UNIQUE respectée).
INSERT INTO clients (nom, prenom, email) VALUES
('Martin',    'Julie',  'julie.martin@email.com'),
('Dubois',    'Thomas', 'thomas.dubois@email.com'),
('Lefebvre',  'Sophie', 'sophie.lefebvre@email.com'),
('Garcia',    'Lucas',  'lucas.garcia@email.com');


-- ------------------------------------------------------------
-- 4) INSERTION DES RESERVATIONS
-- ------------------------------------------------------------
-- Chaque réservation référence un client_id et un concert_id existants.
-- Julie (client 1) et Sophie (client 3) ont chacune réservé
-- 2 concerts différents, pour tester les requêtes de regroupement.
-- Dates et quantités de places volontairement variées.
INSERT INTO reservations (date_reservation, client_id, concert_id, nombre_places) VALUES
('2026-09-01 10:15:00', 1, 1, 2),  -- Julie   -> concert 1 (Daft Punk)
('2026-09-03 14:30:00', 1, 2, 1),  -- Julie   -> concert 2 (Rosalía)
('2026-09-05 09:00:00', 2, 1, 4),  -- Thomas  -> concert 1 (Daft Punk)
('2026-09-10 18:45:00', 3, 3, 3),  -- Sophie  -> concert 3 (Rosalía étape 2)
('2026-09-12 11:20:00', 3, 4, 2),  -- Sophie  -> concert 4 (Stromae)
('2026-09-15 16:00:00', 4, 4, 1);  -- Lucas   -> concert 4 (Stromae)


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
-- Résumé du jeu de données inséré :
--   - 3 artistes (styles et pays différents)
--   - 4 concerts (chacun lié à un artiste existant)
--   - 4 clients (emails uniques)
--   - 6 réservations (dont 2 clients ayant réservé plusieurs concerts)
-- Toutes les clés étrangères référencent des enregistrements déjà
-- existants, garantissant l'intégrité référentielle de la base.
-- ============================================================

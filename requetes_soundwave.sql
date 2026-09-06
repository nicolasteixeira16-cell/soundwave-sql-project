-- ============================================================
-- SCRIPT DE REQUETES SQL - PROJET "SOUNDWAVE"
-- ============================================================
-- Auteur : Nicolas
-- Objectif : Interroger la base SoundWave pour extraire des
--            informations utiles à partir des relations entre tables.
-- SGBD utilisé : PostgreSQL
-- Prérequis : soundwave_create_final.sql et insert_soundwave.sql
--             doivent avoir été exécutés au préalable.
-- ============================================================


-- ------------------------------------------------------------
-- 1) CONCERTS A VENIR AVEC LE NOM DE L'ARTISTE ASSOCIE
-- ------------------------------------------------------------
-- JOIN entre concerts et artistes via artiste_id.
-- Filtre : uniquement les concerts dont la date est postérieure
-- à la date du jour (CURRENT_DATE).
SELECT c.titre, c.date_heure, c.lieu, a.nom AS nom_artiste
FROM concerts c
JOIN artistes a ON c.artiste_id = a.identifiant
WHERE c.date_heure > CURRENT_DATE
ORDER BY c.date_heure;


-- ------------------------------------------------------------
-- 2) RESERVATIONS D'UN CLIENT DONNE (VIA SON EMAIL)
-- ------------------------------------------------------------
-- Double JOIN : clients -> reservations -> concerts.
-- Filtre sur l'email exact du client recherché.
SELECT cl.nom, cl.prenom, cl.email, co.titre, co.date_heure, 
       r.nombre_places, r.date_reservation
FROM clients cl
JOIN reservations r ON cl.identifiant = r.client_id
JOIN concerts co ON r.concert_id = co.identifiant
WHERE cl.email = 'julie.martin@email.com';


-- ------------------------------------------------------------
-- 3) NOMBRE TOTAL DE PLACES RESERVEES PAR CONCERT
-- ------------------------------------------------------------
-- JOIN entre concerts et reservations, regroupement par concert
-- (GROUP BY), puis somme des places réservées (SUM).
SELECT co.titre, SUM(r.nombre_places) AS total_places_reservees
FROM concerts co
JOIN reservations r ON co.identifiant = r.concert_id
GROUP BY co.identifiant, co.titre
ORDER BY co.identifiant;


-- ------------------------------------------------------------
-- 4) CLIENTS AYANT RESERVE AU MOINS 2 CONCERTS DIFFERENTS
-- ------------------------------------------------------------
-- JOIN entre clients et reservations, regroupement par client,
-- puis filtre HAVING sur le nombre de concerts distincts réservés
-- (HAVING est utilisé ici car le filtre porte sur un résultat
-- de fonction d'agrégation - COUNT - ce que WHERE ne permet pas).
SELECT cl.identifiant, cl.nom, cl.prenom, cl.email, 
       COUNT(DISTINCT r.concert_id) AS nombre_concerts_differents
FROM clients cl
JOIN reservations r ON cl.identifiant = r.client_id
GROUP BY cl.identifiant, cl.nom, cl.prenom, cl.email
HAVING COUNT(DISTINCT r.concert_id) >= 2;


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================

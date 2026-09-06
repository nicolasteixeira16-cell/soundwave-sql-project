-- ============================================================
-- SCRIPT DE CREATION DE BASE DE DONNEES - PROJET "SOUNDWAVE"
-- ============================================================
-- Auteur : Nicolas
-- Objectif : Traduire le MPD (Artistes, Concerts, Clients, Réservations)
--            en script SQL de création de base relationnelle.
-- SGBD utilisé : PostgreSQL
-- ============================================================


-- ------------------------------------------------------------
-- 1) CREATION DE LA BASE DE DONNEES
-- ------------------------------------------------------------
-- NB : en PostgreSQL, il n'existe pas d'instruction "USE" comme en MySQL.
-- Une fois la base créée, il faut s'y reconnecter (nouvelle connexion),
-- soit via pgAdmin (clic sur la base), soit via psql avec : \c soundwave
--
-- Équivalent MySQL (pour information / comparaison avec l'énoncé) :
--   CREATE DATABASE soundwave;
--   USE soundwave;
--
-- Équivalent PostgreSQL :
CREATE DATABASE soundwave;

-- >>> Se reconnecter à la base "soundwave" avant d'exécuter la suite <<<
-- Dans psql :  \c soundwave
-- Dans pgAdmin : sélectionner la base "soundwave" puis rouvrir une Query Tool


-- ------------------------------------------------------------
-- 2) TABLE : ARTISTES
-- ------------------------------------------------------------
-- Entité indépendante : ne dépend d'aucune autre table.
CREATE TABLE IF NOT EXISTS public.artistes
(
    identifiant     BIGSERIAL PRIMARY KEY,        -- clé primaire auto-incrémentée
    nom             VARCHAR(100) NOT NULL,
    style_musical   VARCHAR(100) NOT NULL,
    paie            VARCHAR(100) NOT NULL
);


-- ------------------------------------------------------------
-- 3) TABLE : CLIENTS
-- ------------------------------------------------------------
-- Entité indépendante : ne dépend d'aucune autre table.
-- La colonne email est UNIQUE : deux clients ne peuvent pas partager le même email.
CREATE TABLE IF NOT EXISTS public.clients
(
    identifiant     BIGSERIAL PRIMARY KEY,
    nom             VARCHAR(100) NOT NULL,
    prenom          VARCHAR(100) NOT NULL,
    email           VARCHAR(255) NOT NULL,

    CONSTRAINT clients_email_key UNIQUE (email)
);


-- ------------------------------------------------------------
-- 4) TABLE : CONCERTS
-- ------------------------------------------------------------
-- Règle métier : "Un concert est obligatoirement lié à un artiste."
-- => la colonne artiste_id est NOT NULL (obligatoire)
-- => contrainte FOREIGN KEY vers artistes(identifiant)
CREATE TABLE IF NOT EXISTS public.concerts
(
    identifiant     BIGSERIAL PRIMARY KEY,
    titre           VARCHAR(200) NOT NULL,
    date_heure      TIMESTAMP NOT NULL,
    lieu            VARCHAR(200) NOT NULL,
    artiste_id      BIGINT NOT NULL,               -- référence obligatoire vers un artiste

    CONSTRAINT fk_concert_artiste
        FOREIGN KEY (artiste_id)
        REFERENCES public.artistes (identifiant)
        ON DELETE RESTRICT                          -- empêche de supprimer un artiste ayant des concerts
);


-- ------------------------------------------------------------
-- 5) TABLE : RESERVATIONS
-- ------------------------------------------------------------
-- Règle métier : "Une réservation ne peut exister que si le client
--                 et le concert existent déjà."
-- => client_id et concert_id sont NOT NULL
-- => deux contraintes FOREIGN KEY garantissent que ces références
--    pointent vers des lignes réellement existantes dans clients et concerts
CREATE TABLE IF NOT EXISTS public.reservations
(
    identifiant       BIGSERIAL PRIMARY KEY,
    date_reservation  TIMESTAMP NOT NULL,
    client_id         BIGINT NOT NULL,
    concert_id        BIGINT NOT NULL,
    nombre_places     INTEGER NOT NULL,

    CONSTRAINT fk_reservation_client
        FOREIGN KEY (client_id)
        REFERENCES public.clients (identifiant)
        ON DELETE RESTRICT,                         -- empêche de supprimer un client ayant des réservations

    CONSTRAINT fk_reservation_concert
        FOREIGN KEY (concert_id)
        REFERENCES public.concerts (identifiant)
        ON DELETE RESTRICT,                         -- empêche de supprimer un concert ayant des réservations

    CONSTRAINT check_nombre_places_positif
        CHECK (nombre_places > 0)                   -- contrainte métier : au moins 1 place réservée
);


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
-- Résumé des contraintes d'intégrité mises en place :
--   - PRIMARY KEY (via BIGSERIAL) sur l'identifiant de chaque table
--   - FOREIGN KEY : concerts -> artistes, reservations -> clients / concerts
--   - NOT NULL sur toutes les clés étrangères = relation obligatoire (cardinalité "1")
--   - UNIQUE sur l'email des clients = pas de doublons
--   - CHECK sur nombre_places = cohérence métier (pas de réservation à 0 place)
--   - ON DELETE RESTRICT = empêche la suppression d'une ligne encore référencée,
--     ce qui garantit la cohérence des données (pas de réservation orpheline)
-- ============================================================

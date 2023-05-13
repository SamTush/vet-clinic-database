/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals
WHERE name LIKE '%mon';

SELECT * FROM animals
WHERE date_of_birth >= '2016-01-01' AND date_of_birth <= '2019-12-31';

SELECT * FROM animals
WHERE neutered = 't' and escape_attempts < 3;

SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

SELECT * FROM animals
WHERE neutered = 't';

SELECT * FROM animals
WHERE name <> 'Gabumon';

SELECT * FROM animals
WHERE weight_kg >= 10.4 AND weight_kg <=17.3;


-- Add a column species

ALTER TABLE animals ADD COLUMN species VARCHAR(50);

-- transactions

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT species from animals;
ROLLBACK;
SELECT species from animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT weight_change;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO weight_change;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, AVG(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals                   
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- Vet clinic database: query multiple tables
SELECT animals.name 
FROM animals 
JOIN owners ON animals.owner_id = owners.id 
WHERE owners.full_name = 'Melody Pond';

SELECT animals.name 
FROM animals 
JOIN species ON animals.species_id = species.id 
WHERE species.name LIKE 'Pokemon';

SELECT owners.full_name, animals.name 
FROM owners 
LEFT JOIN animals ON animals.owner_id = owners.id;

SELECT species.name, COUNT(species.name) AS number 
FROM species JOIN animals ON animals.species_id = species.id
GROUP BY species.name;

SELECT animals.name, owners.full_name, species.name AS species_name FROM animals
JOIN owners ON animals.owner_id = owners.id  
JOIN species ON animals.species_id = species.id 
WHERE owners.full_name LIKE 'Jennifer Orwell' AND  
species.name LIKE 'Digimon';

SELECT animals.name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE animals.escape_attempts = 0 
AND owners.full_name LIKE 'Dean Winchester';

SELECT owners.full_name, COUNT(animals.id) as num_animals_owned
FROM animals
JOIN owners ON animals.owner_id = owners.id
GROUP BY owners.full_name
ORDER BY num_animals_owned DESC
LIMIT 1;

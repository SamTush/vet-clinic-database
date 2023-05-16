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

SELECT animals.name FROM animals JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id WHERE vet_id = 1 ORDER BY date_visited DESC LIMIT 1;

SELECT COUNT(DISTINCT animal_id) FROM visits
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

SELECT vets.name, species.name AS specialization FROM vets 
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

SELECT animals.name FROM animals
JOIN visits ON animals.id = visits.animal_id  
JOIN vets ON visits.vet_id = vets.id   
WHERE vets.name LIKE 'Stephanie Mendez'          
AND visits.date_visited BETWEEN '2020-4-1' AND '2020-08-30';

SELECT animals.name, COUNT(*) AS num_visits
FROM animals
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.id
ORDER BY num_visits DESC
LIMIT 1;

SELECT animals.name, visits.date_visited
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_visited ASC
LIMIT 1;

SELECT animals.name AS animal_name, vets.name AS vet_name, visits.date_visited
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.date_visited DESC
LIMIT 1;

SELECT COUNT(*)
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN specializations ON vets.id = specializations.vet_id
JOIN animals ON visits.animal_id = animals.id
JOIN species ON animals.species_id = species.id
WHERE NOT EXISTS (
  SELECT *
  FROM specializations s
  WHERE s.vet_id = vets.id AND s.species_id = species.id
);

SELECT species.name, COUNT(*) AS num_visits
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN species ON animals.species_id = species.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy'
GROUP BY species.name    
ORDER BY num_visits DESC 
LIMIT 1;

CREATE INDEX idx_animal_id ON visits (animal_id);

SET work_mem = '128MB';

ANALYZE visits;

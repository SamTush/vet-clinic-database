/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOL,
  weight_kg DECIMAL,
  species VARCHAR(50)
);

-- Vet clinic database: query multiple tables

CREATE TABLE owners (
id SERIAL PRIMARY KEY,
full_name VARCHAR(255),
age INTEGER);

CREATE TABLE species (                                                                                                                            
id SERIAL PRIMARY KEY,
name VARCHAR(150)
);

ALTER TABLE animals DROP COLUMN IF EXISTS species;

ALTER TABLE animals ADD COLUMN species_id INTEGER REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id INTEGER REFERENCES owners(id);


-- vet clinic database: Add 'join table' for visits
CREATE TABLE vets (   
id SERIAL PRIMARY KEY, 
name VARCHAR(150),
age INTEGER, 
date_of_graduation DATE);

CREATE TABLE specializations (
id SERIAL PRIMARY KEY,
vet_id INTEGER REFERENCES vets(id),
species_id INTEGER REFERENCES species(id)
);

ALTER TABLE animals ADD CONSTRAINT animals_pk PRIMARY KEY (id);

CREATE TABLE visits (
id SERIAL PRIMARY KEY,
animal_id INTEGER REFERENCES animals (id),
vet_id INTEGER REFERENCES vets (id),
date_visited DATE
);

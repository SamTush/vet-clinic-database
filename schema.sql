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

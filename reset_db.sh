#!/bin/bash

# Drop the existing database
echo "Dropping database..."
rails db:drop

# Create the database
echo "Creating database..."
rails db:create

# Run migrations to set up the schema
echo "Running migrations..."
rails db:migrate

# Seed the database with initial data
echo "Seeding database..."
rails db:seed

echo "Database reset complete."

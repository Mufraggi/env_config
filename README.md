# Dhall Configuration Template

This repository provides a template for managing application configurations using the Dhall language. It demonstrates how to structure a multi-service project with shared configuration types and utilities.

## Overview

Dhall is a programmable configuration language that you can think of as: JSON + functions + types + imports. It provides a safe, maintainable way of managing complex configurations with features like:

- Strong static typing
- No side effects
- Guaranteed termination
- Built-in functions for manipulating data
- Imports with integrity checking

This template shows how to leverage these features to create a maintainable configuration system for multiple services.

## Repository Structure

```
.
├── Makefile                  # Automation for common Dhall operations
├── common
│   ├── functions             # Shared utility functions
│   │   └── mongo.dhall       # MongoDB URI generator
│   └── types                 # Shared configuration types
│       ├── auth.dhall        # Authentication settings
│       ├── cache.dhall       # Cache configuration
│       ├── messaging.dhall   # Messaging service settings
│       ├── mongo.dhall       # MongoDB connection settings
│       ├── postgres.dhall    # PostgreSQL connection settings
│       └── smtp.dhall        # SMTP settings
└── services                  # Individual service configurations
    ├── backend               # Backend service
    │   ├── config.dhall      # Service-specific configuration
    │   └── default.dhall     # Entry point for backend config
    └── etl                   # ETL service
        ├── config.dhall      # Service-specific configuration
        └── default.dhall     # Entry point for ETL config
```

## Getting Started

### Prerequisites

Install Dhall and related tools:

```bash
# macOS
brew install dhall dhall-json

# Linux (using Nix)
nix-env -i dhall dhall-json

# Other platforms
# See: https://dhall-lang.org/getting-started.html
```

### Using the Template

1. Clone this repository
2. Customize the types in `common/types/` for your application
3. Create or update service configurations in the `services/` directory
4. Use the Makefile to validate and generate JSON configurations

### Makefile Commands

```bash
# View available commands
make help

# Validate all Dhall files
make validate

# Format all Dhall files
make format

# Generate JSON configurations for all services
make generate-configs

# Generate config for a specific service
make generate-backend
make generate-etl

# Clean generated files
make clean
```

## Working with Dhall

### Example: Generating MongoDB URI

This template includes a function for generating MongoDB connection URIs:

```dhall
-- Import the MongoDB configuration type
let MongoConfig = ../types/mongo.dhall

-- Import the Optional module from Prelude
let Optional = https://prelude.dhall-lang.org/Optional/package.dhall

-- Function to generate MongoDB URI
let generateMongoURI
    : MongoConfig → Text
    = λ(config : MongoConfig) →
      let base = "mongodb://" ++ config.user ++ ":" ++ config.password ++ "@"
                 ++ config.host ++ ":" ++ Natural/show config.port ++ "/"
                 ++ config.database
      
      in  Optional.fold
            Text
            config.replicaSet
            Text
            (λ(replica : Text) → base ++ "?replicaSet=" ++ replica)
            base

in  generateMongoURI
```

### Example: Service Configuration

```dhall
-- Import common types and functions
let MongoConfig = ../../common/types/mongo.dhall
let PostgresConfig = ../../common/types/postgres.dhall
let generateMongoURI = ../../common/functions/mongo.dhall

-- Service-specific configuration
let config =
      { environment = "development"
      , debug = True
      , port = 8080
      , mongo =
          { user = "dbuser"
          , password = "dbpass"
          , host = "localhost"
          , port = 27017
          , database = "myapp"
          , replicaSet = Some "rs0"
          }
      }

-- Generate MongoDB URI and include it in the final config
in  config // { mongoURI = generateMongoURI config.mongo }
```

## Benefits of Using Dhall

- **Type Safety**: Catch configuration errors before deployment
- **DRY Configurations**: Share common settings across services
- **Maintainability**: Use functions to derive complex values
- **Validation**: Ensure configurations meet your requirements
- **Versioning**: Track configuration changes in version control

## Next Steps

- Explore [Dhall documentation](https://dhall-lang.org/) for more advanced features
- Add more service configurations as needed
- Create CI/CD pipelines that validate and generate configs

## License

This template is licensed under the MIT License - see the LICENSE file for details.
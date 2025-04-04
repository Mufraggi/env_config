# Makefile for Dhall operations
# Optimized for the project structure with common types and multiple services

# Configuration
DHALL_DIR := .
OUTPUT_DIR := ./output
COMMON_DIR := ./common
SERVICES_DIR := ./services

# Services (auto-detected from directory structure)
SERVICES := $(notdir $(wildcard $(SERVICES_DIR)/*))

# Environments
ENVIRONMENTS := prod preprod local default

# Default shell
SHELL := /bin/bash

# Default target
.PHONY: help
help:
	@echo "Dhall Project Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  validate           - Check all Dhall files for errors"
	@echo "  format             - Format all Dhall files"
	@echo "  freeze             - Freeze all imports in Dhall files"
	@echo "  generate-configs   - Generate JSON configs for all services (default environment)"
	@echo "  generate-<service>           - Generate JSON config for specific service (default environment)"
	@echo "  generate-<service>-<env>     - Generate JSON config for specific service and environment"
	@echo "                                 where <env> is one of: prod, preprod, local"
	@echo "  lint               - Lint Dhall files"
	@echo "  clean              - Remove generated files"
	@echo "  help               - Show this help message"
	@echo ""
	@echo "Available services: $(SERVICES)"
	@echo "Available environments: prod, preprod, local, default"

# Find all Dhall files in the project
DHALL_FILES := $(shell find $(DHALL_DIR) -name "*.dhall" -type f)

# Validate all Dhall files
.PHONY: validate
validate:
	@echo "Validating Dhall files..."
	@for file in $(DHALL_FILES); do \
	   echo "Checking $$file"; \
	   dhall --file "$$file" > /dev/null || exit 1; \
	done
	@echo "All Dhall files are valid!"

# Format all Dhall files
.PHONY: format
format:
	@echo "Formatting Dhall files..."
	@for file in $(DHALL_FILES); do \
	   echo "Formatting $$file"; \
	   dhall format --inplace "$$file" || exit 1; \
	done
	@echo "All Dhall files formatted!"

# Freeze imports in all Dhall files
.PHONY: freeze
freeze:
	@echo "Freezing Dhall imports..."
	@for file in $(DHALL_FILES); do \
	   echo "Freezing imports in $$file"; \
	   dhall freeze --inplace "$$file" || exit 1; \
	done
	@echo "All imports frozen!"

# Generate JSON configs for all services (default environment)
.PHONY: generate-configs
generate-configs: $(addprefix generate-,$(SERVICES))
	@echo "All service configs generated!"

# Generate individual service configs (default environment)
.PHONY: $(addprefix generate-,$(SERVICES))
$(addprefix generate-,$(SERVICES)):
	@service=$(subst generate-,,$@); \
	echo "Generating config for $$service service (default environment)..."; \
	dhall-to-json --file "$(SERVICES_DIR)/$$service/default.dhall" --output "$$service-config.json"; \
	echo "Config generated: $$service-config.json"

# Generate service configs with specific environment
.PHONY: $(foreach svc,$(SERVICES),$(foreach env,$(ENVIRONMENTS),generate-$(svc)-$(env)))
$(foreach svc,$(SERVICES),$(foreach env,$(ENVIRONMENTS),generate-$(svc)-$(env))):
	@target=$@; \
	service=$$(echo $$target | sed -E 's/generate-([^-]+)-.*/\1/'); \
	environment=$$(echo $$target | sed -E 's/generate-[^-]+-(.+)/\1/'); \
	echo "Generating config for $$service service with $$environment environment..."; \
	if [ -f "$(SERVICES_DIR)/$$service/$$environment.dhall" ]; then \
		dhall-to-json --file "$(SERVICES_DIR)/$$service/$$environment.dhall" --output "$$service-$$environment-config.json"; \
		echo "Config generated: $$service-$$environment-config.json"; \
	else \
		echo "Error: Environment file $(SERVICES_DIR)/$$service/$$environment.dhall not found"; \
		exit 1; \
	fi

# Lint Dhall files
.PHONY: lint
lint:
	@echo "Linting Dhall files..."
	@if command -v dhall-lint > /dev/null; then \
	   for file in $(DHALL_FILES); do \
	      echo "Linting $$file"; \
	      dhall-lint "$$file" || exit 1; \
	   done; \
	else \
	   echo "Warning: dhall-lint not found. Please install it to use this feature."; \
	fi

# Clean generated files
.PHONY: clean
clean:
	@echo "Cleaning generated files..."
	@rm -f *-config.json
	@rm -rf $(OUTPUT_DIR)
	@echo "Clean complete!"
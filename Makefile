# Makefile for Dhall operations
# Optimized for the project structure with common types and multiple services

# Configuration
DHALL_DIR := .
OUTPUT_DIR := ./output
COMMON_DIR := ./common
SERVICES_DIR := ./services

# Services (auto-detected from directory structure)
SERVICES := $(notdir $(wildcard $(SERVICES_DIR)/*))

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
	@echo "  generate-configs   - Generate JSON configs for all services"
	@echo "  generate-backend   - Generate JSON config for backend service"
	@echo "  generate-etl       - Generate JSON config for etl service"
	@echo "  lint               - Lint Dhall files"
	@echo "  clean              - Remove generated files"
	@echo "  help               - Show this help message"
	@echo ""
	@echo "Available services: $(SERVICES)"

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

# Generate JSON configs for all services
.PHONY: generate-configs
generate-configs: $(addprefix generate-,$(SERVICES))
	@echo "All service configs generated!"

# Generate individual service configs
.PHONY: $(addprefix generate-,$(SERVICES))
$(addprefix generate-,$(SERVICES)):
	@service=$(subst generate-,,$@); \
	echo "Generating config for $$service service..."; \
	dhall-to-json --file "$(SERVICES_DIR)/$$service/default.dhall" --output "$$service-config.json"; \
	echo "Config generated: $$service-config.json"

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
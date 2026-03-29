.PHONY: help setup dev build publish publish-dry deps test format quality docs docs-serve clean themes-clear podman-build podman-run podman-stop podman-restart podman-logs podman-clean podman-deploy podman-push

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: deps ## Install deps and compile library + demo
	mix compile
	cd demo && mix compile

deps: ## Install dependencies for library and demo
	mix deps.get
	cd demo && mix deps.get

dev: ## Start demo app with iex
	cd demo && iex -S mix phx.server

build: ## Build hex package
	mix hex.build

publish: ## Publish to hex.pm
	mix hex.publish

publish-dry: ## Dry-run hex publish
	mix hex.publish --dry-run

test: ## Run tests
	mix test

format: ## Format code in library and demo
	mix format
	cd demo && mix format

quality: ## Run format check + credo + dialyzer
	mix quality

docs: ## Generate documentation
	mix docs

docs-serve: docs ## Generate and serve docs on port 5555
	npx five-server doc --port 5555

clean: ## Clean build artifacts
	mix clean
	cd demo && mix clean

themes-clear: ## Clear cached themes (forces re-download on next access)
	cd demo && mix eval 'File.rm_rf!(Path.join(System.tmp_dir!(), "pure-admin-themes")); IO.puts("Theme cache cleared")'

# === Docker Commands ===
# Docker image settings
DOCKER_IMAGE_NAME = keen-pure-admin-demo
DOCKER_REGISTRY = registry.km8.es
DOCKER_TAG = production
DOCKER_CONTAINER_NAME = keen-pure-admin-demo
DOCKER_PORT = 4000

podman-build: ## Build Docker image
	@echo "Building Docker image: $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)"
	podman build -f demo/Dockerfile -t $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) .
	@echo "Docker image built successfully!"

podman-run: ## Run Docker container
	@echo "Starting Docker container on port $(DOCKER_PORT)"
	@if [ $$(podman ps -q -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		echo "Container is already running at http://localhost:$(DOCKER_PORT)"; \
	elif [ $$(podman ps -aq -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		echo "Starting existing container"; \
		podman start $(DOCKER_CONTAINER_NAME); \
		echo "Application is running at: http://localhost:$(DOCKER_PORT)"; \
	else \
		echo "Creating and starting new container"; \
		podman run -d --name $(DOCKER_CONTAINER_NAME) -p $(DOCKER_PORT):4000 \
			-e SECRET_KEY_BASE=$${SECRET_KEY_BASE:-$$(mix phx.gen.secret)} \
			-e PHX_HOST=$${PHX_HOST:-localhost} \
			$(DOCKER_IMAGE_NAME):$(DOCKER_TAG); \
		echo "Application is running at: http://localhost:$(DOCKER_PORT)"; \
	fi

podman-stop: ## Stop Docker container
	@echo "Stopping Docker container"
	@if [ $$(podman ps -q -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		podman stop $(DOCKER_CONTAINER_NAME); \
		echo "Container stopped successfully"; \
	else \
		echo "Container is not running"; \
	fi

podman-restart: podman-stop podman-run ## Restart Docker container

podman-logs: ## Show Docker container logs
	@if [ $$(podman ps -aq -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		podman logs -f $(DOCKER_CONTAINER_NAME); \
	else \
		echo "Container does not exist"; \
	fi

podman-clean: podman-stop ## Remove Docker container and image
	@echo "Cleaning up Docker resources"
	@if [ $$(podman ps -aq -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		podman rm $(DOCKER_CONTAINER_NAME); \
		echo "Container removed"; \
	fi
	@if [ $$(podman images -q $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)) ]; then \
		podman rmi $(DOCKER_IMAGE_NAME):$(DOCKER_TAG); \
		echo "Image removed"; \
	fi

podman-deploy: podman-build podman-run ## Build and run Docker container

podman-push: ## Tag and push image to registry
	@echo "Tagging and pushing image to $(DOCKER_REGISTRY)"
	podman tag $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_TAG)
	podman push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_TAG)
	@echo "Image pushed to $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_TAG)"

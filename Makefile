.PHONY: setup dev build publish publish-dry deps test format quality docs docs-serve clean podman-build podman-run podman-stop podman-restart podman-logs podman-clean podman-deploy podman-push

setup: deps
	mix compile
	cd demo && mix compile

deps:
	mix deps.get
	cd demo && mix deps.get

dev:
	cd demo && iex -S mix phx.server

build:
	mix hex.build

publish:
	mix hex.publish

publish-dry:
	mix hex.publish --dry-run

test:
	mix test

format:
	mix format
	cd demo && mix format

quality:
	mix quality

docs:
	mix docs

docs-serve: docs
	npx five-server doc --port 5555

clean:
	mix clean
	cd demo && mix clean

# === Docker Commands ===
# Docker image settings
DOCKER_IMAGE_NAME = keen-pure-admin-demo
DOCKER_REGISTRY = registry.km8.es
DOCKER_TAG = production
DOCKER_CONTAINER_NAME = keen-pure-admin-demo
DOCKER_PORT = 4000

# Build Docker image
podman-build:
	@echo "Building Docker image: $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)"
	podman build -f demo/Dockerfile -t $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) .
	@echo "Docker image built successfully!"

# Run Docker container
podman-run:
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

# Stop Docker container
podman-stop:
	@echo "Stopping Docker container"
	@if [ $$(podman ps -q -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		podman stop $(DOCKER_CONTAINER_NAME); \
		echo "Container stopped successfully"; \
	else \
		echo "Container is not running"; \
	fi

# Restart Docker container
podman-restart: podman-stop podman-run

# Show Docker container logs
podman-logs:
	@if [ $$(podman ps -aq -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		podman logs -f $(DOCKER_CONTAINER_NAME); \
	else \
		echo "Container does not exist"; \
	fi

# Remove Docker container and image
podman-clean: podman-stop
	@echo "Cleaning up Docker resources"
	@if [ $$(podman ps -aq -f name=$(DOCKER_CONTAINER_NAME)) ]; then \
		podman rm $(DOCKER_CONTAINER_NAME); \
		echo "Container removed"; \
	fi
	@if [ $$(podman images -q $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)) ]; then \
		podman rmi $(DOCKER_IMAGE_NAME):$(DOCKER_TAG); \
		echo "Image removed"; \
	fi

# Build and run Docker container
podman-deploy: podman-build podman-run

# Tag and push image to registry
podman-push:
	@echo "Tagging and pushing image to $(DOCKER_REGISTRY)"
	podman tag $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_TAG)
	podman push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_TAG)
	@echo "Image pushed to $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_TAG)"

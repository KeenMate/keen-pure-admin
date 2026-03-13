.PHONY: setup dev build publish publish-dry deps test format quality docs docs-serve clean

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

.PHONY: generate lint breaking

generate:
	buf generate

lint:
	buf lint

breaking:
	buf breaking --against '.git#branch=main'

.PHONY: build

build:
	yarn
	yarn build:css
	go build -o build/gwiki ./cmd/gwiki

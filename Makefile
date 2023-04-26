APP_NAME = desktop
BUILDER_IMAGE = ghcr.io/innoai-tech/$(APP_NAME)-wails-builder

dev:
	wails dev

build.webapp:
	cd ./frontend && pnpm install && pnpm run build

build.app: pkg.windows pkg.macos pkg.linux

DOCKER_MAKE = docker run -it \
	-v=${PWD}:/go/src \
	-w=/go/src \
	--entrypoint=/usr/bin/make

pkg.windows:
	wails build -platform windows/amd64 -o $(APP_NAME)-windows-amd64.exe
	wails build -platform windows/arm64 -o $(APP_NAME)-windows-arm64.exe

pkg.linux:
	$(DOCKER_MAKE) --platform=linux/amd64 $(BUILDER_IMAGE) pkg.linux.amd64
	$(DOCKER_MAKE) --platform=linux/arm64 $(BUILDER_IMAGE) pkg.linux.arm64

pkg.linux.amd64:
	CXX=x86_64-linux-gnu-g++ CC=x86_64-linux-gnu-gcc AR=x86_64-linux-gnu-gcc-ar \
		wails build -platform linux/amd64 -o $(APP_NAME)-linux-amd64

pkg.linux.arm64:
	CXX=aarch64-linux-gnu-g++ CC=aarch64-linux-gnu-gcc AR=aarch64-linux-gnu-gcc-ar \
		wails build -platform linux/arm64 -o $(APP_NAME)-linux-arm64

pkg.macos:
	wails build -platform darwin/universal

build.builder:
	docker buildx build --push --platform=linux/amd64,linux/arm64 -t $(BUILDER_IMAGE) -f ./hack/Dockerfile .

setup:
	npm install -g pnpm
	go install github.com/wailsapp/wails/v2/cmd/wails@latest
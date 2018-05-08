DOCKERIMAGE = welance/craft
TAG = dev
# for pigeoning
LATEST_TAG := $(shell git describe --tags --abbrev=0)
CURRENT_VER := $(shell git describe)
# git status (to check if the working copy is clean)
CURR_CHANGES := $(shell git status --short | wc -l)


default: docker-build

clean:
	@echo nothing to do

docker: docker-build

docker-build:
	@echo build image
	docker build -t $(DOCKERIMAGE):$(TAG) -f ./build/docker/Dockerfile .
	@echo done

docker-publish: docker-build
	@echo push image
	docker push $(DOCKERIMAGE)
	@echo done

pigeons:
	@echo current version is $(CURRENT_VER) latest tag $(LATEST_TAG) 
	@if [ -z "$$(git status --porcelain)" ]; \
		then \
		git archive \
		--format=zip HEAD \
		`git diff --name-status HEAD $(LATEST_TAG) | grep -v '^D' | awk '{print $$2}'` > dist/pigeon.zip; \
	else \
		echo working directory is not clean, abort abort.; fi

DOCKERIMAGE = welance/craft
TAG = dev

default: docker-build

clean:
	@echo nothing to do

docker: docker-build

docker-build:
	@echo build image
	docker build -t $(DOCKERIMAGE):$(TAG) -f ./docker/craft/Dockerfile .
	@echo done

docker-publish: docker-build
	@echo push image
	docker push $(DOCKERIMAGE)
	@echo done


ALLENNLP_BRANCH = torchvision
ALLENNLP_COMMIT_SHA = $(shell git ls-remote https://github.com/allenai/allennlp $(ALLENNLP_BRANCH) | cut -f 1)
CONFIG = "https://raw.githubusercontent.com/allenai/allennlp/master/test_fixtures/simple_tagger/experiment.json"
DOCKER_TAG = latest
DOCKER_IMAGE_NAME = epwalsh/allennlp-beaker:$(DOCKER_TAG)
DOCKER_RUN_CMD = docker run --rm \
		-v $$HOME/.allennlp:/root/.allennlp \
		-v $$HOME/.cache/torch:/root/.cache/torch \
		-v $$HOME/nltk_data:/root/nltk_data

.PHONY : docker-image
docker-image :
	docker build \
		--pull \
		-f Dockerfile \
		--build-arg ALLENNLP=$(DOCKER_TORCH_VERSION) \
		--build-arg ALLENNLP_COMMIT_SHA=$(ALLENNLP_COMMIT_SHA) \
		-t $(DOCKER_IMAGE_NAME) .

.PHONY : docker-run
docker-run :
	$(DOCKER_RUN_CMD) --gpus all --env CONFIG=$(CONFIG) $(DOCKER_IMAGE_NAME)

.PHONY : docker-push
docker-push : docker-image
	docker push $(DOCKER_IMAGE_NAME)

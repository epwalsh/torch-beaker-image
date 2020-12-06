ALLENNLP_BRANCH = torchvision
ALLENNLP_COMMIT_SHA = $(shell git ls-remote https://github.com/allenai/allennlp $(ALLENNLP_BRANCH) | cut -f 1)

TORCH = "torch==1.7.0+cu101 torchvision==0.8.1+cu101 torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html"
DOCKER_TAG = $(ALLENNLP_COMMIT_SHA)-cuda101

DOCKER_IMAGE_NAME = epwalsh/allennlp-beaker:$(DOCKER_TAG)
DOCKER_RUN_CMD = docker run --rm \
		-v $$HOME/.allennlp:/root/.allennlp \
		-v $$HOME/.cache/torch:/root/.cache/torch \
		-v $$HOME/nltk_data:/root/nltk_data

CONFIG = "https://raw.githubusercontent.com/allenai/allennlp/master/test_fixtures/simple_tagger/experiment.json"

.PHONY : docker-image
docker-image :
	docker build \
		--pull \
		-f Dockerfile \
		--build-arg TORCH=$(TORCH) \
		--build-arg ALLENNLP_COMMIT_SHA=$(ALLENNLP_COMMIT_SHA) \
		-t $(DOCKER_IMAGE_NAME) .

.PHONY : docker-run
docker-run :
	$(DOCKER_RUN_CMD) \
		--gpus all \
		--env CONFIG=$(CONFIG) \
		--env PIP_EXTRAS=git+https://github.com/allenai/allennlp.git@torchvision \
		$(DOCKER_IMAGE_NAME)

.PHONY : docker-push
docker-push : docker-image
	docker push $(DOCKER_IMAGE_NAME)

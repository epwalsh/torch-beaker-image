# torch-beaker-image

This repo contains a Docker suitable for running AllenNLP experiments on Beaker.
The latest images will be pushed to Docker Hub at [epwalsh/allennlp-beaker](https://hub.docker.com/repository/docker/epwalsh/allennlp-beaker).

You can use the [example Beaker config](./beaker.yml) to submit experiments based on this image to Beaker. You just need to change the `CONFIG`
environment variable and, optionally, if you need other dependencies or a specific commit of AllenNLP, set the `PIP_EXTRAS` environment variable.
For example, `PIP_EXTRAS: "git+https://github.com/allenai/allennlp.git@torchvision git+https://github.com/allenai/allennlp-models.git@vision"`.

You can then submit experiments to Beaker with:

```bash
beaker experiment create --name {EXPERIMENT_NAME} -f beaker.yml
```

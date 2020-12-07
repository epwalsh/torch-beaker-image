# This Dockerfile creates an environment suitable for downstream usage of AllenNLP.
# It's built from a wheel installation of allennlp.

FROM python:3.8

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# Tell nvidia-docker the driver spec that we need as well as to
# use all available devices, which are mounted at /usr/local/nvidia.
# The LABEL supports an older version of nvidia-docker, the env
# variables a newer one.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
LABEL com.nvidia.volumes.needed="nvidia_driver"

WORKDIR /stage/

# Install torch ecosystem first. This build arg should be in the form of a version requirement,
# like 'torch==1.7' or 'torch==1.7+cu110 -f https://download.pytorch.org/whl/torch_stable.html'.
ARG TORCH="torch torchvision"
RUN pip install --no-cache-dir ${TORCH}

ARG ALLENNLP_COMMIT_SHA
RUN pip install --no-cache-dir git+https://github.com/allenai/allennlp.git@${ALLENNLP_COMMIT_SHA} \
    && pip uninstall -y dataclasses

WORKDIR /app/

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

# Disable parallelism in tokenizers because it doesn't help, and sometimes hurts.
ENV TOKENIZERS_PARALLELISM 0

# This slows some CPU computations down but avoids the potential for certain dead locks
# when using multiprocessing with the 'fork' spawn method.
# See https://discuss.pytorch.org/t/pytorch-cpu-hangs-on-nn-linear/17748/4.
ENV OMP_NUM_THREADS 1

ENTRYPOINT ["./entrypoint.sh"]

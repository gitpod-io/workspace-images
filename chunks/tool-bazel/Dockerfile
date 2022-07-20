ARG base
FROM ${base}

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

# store the blaze/bazel cache in a place where it will be persisted
# See also https://docs.bazel.build/versions/main/output_directories.html
RUN mkdir -p /home/gitpod/.cache/bazel && ln -s /home/gitpod/.cache/bazel /workspace/.bazel

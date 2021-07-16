FROM layla7/pytorch-cuda:cuda11.1-ubuntu20.04-py39

COPY install.sh /workspace

RUN bash install.sh && \
	rm install.sh

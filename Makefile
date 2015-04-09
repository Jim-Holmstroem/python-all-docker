IMAGE=jimho/python-all

build:
	docker build -t ${IMAGE} .

run:
	docker run --rm -it ${IMAGE} bash

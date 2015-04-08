IMAGE=jimho/python-science

build:
	docker build -t ${IMAGE} .

run:
	docker run --rm -it ${IMAGE} bash

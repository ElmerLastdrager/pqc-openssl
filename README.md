# Speedtest liboqs for PQC algorithms

How to build and run:

	podman build . -t oqs
	podman run -it oqs openssl list --kem-algorithms
	podman run -it oqs openssl speed mayo2 falcon512

For docker instead of podman:

	docker build . -t oqs
	docker run -it oqs openssl list --kem-algorithms
	docker run -it oqs openssl speed mayo2 falcon512

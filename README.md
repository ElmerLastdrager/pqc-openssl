# Speedtest liboqs for PQC algorithms

How to build and run:

> podman build . -t oqs
> podman run -it oqs openssl list --kem-algorithms
> podman run -it oqs openssl speed mayo2  

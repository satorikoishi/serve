cd docker && ./my_build_image.sh -nc
docker push jwkaguya/torchserve:latest-gpu
cd ../kubernetes/kserve && ./build_image.sh -nc
docker push jwkaguya/torchserve-kfs:latest-gpu

docker run -name code -d sgtwilko/rpi-raspbian-opencv
docker exec -it $(docker ps --filter="name=code" --format "{{.ID}}") bash


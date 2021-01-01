# Docker Wordpress Template

```bash
cp .env.docker .env
cp wp-config.php.docker wp-config.php
sudo docker-compose up --build
```

```bash
sudo docker exec -it site_name_ctr /bin/bash
```
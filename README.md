# Wordpress in docker

## Solution

```bash
git clone https://github.com/hlepesant/tppolytech.git
sh ./getwp.sh
docker-compose up -d
sudo sh -c 'echo "127.0.0.1     wp.polytech.io" >> /etc/hosts'
```

Then browse [http://wp.polytech.io:8080/](http://wp.polytech.io:8080/)

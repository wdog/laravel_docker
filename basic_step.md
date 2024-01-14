```bash
# create docker base project
git clone git@github.com:wdog/laravel_docker.git BASE
cd BASE/
# create laravel app
composer create-project laravel/laravel src
```

```bash
# set parameter for creating docker and
vim src/.env

DB_HOST=mysql
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=laravel
```


```bash
# create containers
docker-compose --env-file=src/.env build
# start
docker-compose --env-file=src/.env up -d

# art in an alias
# docker-compose exec laravel-php php artisan
art migrate
docker-compose exec laravel-php npm install
```

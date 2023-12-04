# Install Laravel

```bash
# base_dir/src
docker run --rm --user 1000:1000 -v $PWD:/opt -w /opt composer:latest composer create-project laravel/laravel src
```

**Fill `.env` in src folder and copy into `base_dir`** for docker configuration

```bash
vim src/.env
cp src/.env .
```

## build and run containers

```bash
cd src
chmod 777 storage -R
docker-compose up -d
```

npm is inside laravel-php container

```bash
docker-compose exec laravel-php npm install
```

# configure VITE

```bash
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: {
        hmr: {
            host: "localhost",
            // if using https
            https: true,
        },
        watch: {
            usePolling: true,
        },
    },

})
```

## INSTALL TAILWIND

```bash
docker-compose exec laravel-php npm install -D tailwindcss postcss autoprefixer @tailwindcss/forms
docker-compose exec laravel-php npx tailwindcss init -p
```

Add the paths to all of your template files in your tailwind.config.js file.

```bash
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./resources/**/*.blade.php", "./resources/**/*.js"],
  theme: {
    extend: {},
  },
  plugins: [require("@tailwindcss/forms")],
}
```

```bash
# resources/css/app.css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

```bash
docker-compose exec laravel-php npm run dev -- --host
# ....dev
```

## SSL

```bash
cd nginx
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048   \
        -keyout ./ssl/nginx-selfsigned.key \
        -out ./ssl/nginx-selfsigned.crt \
        -subj "/C=IT/ST=Italy/L=NoWhere/O=NoOrg/OU=HQ"
sudo openssl dhparam -out ./ssl/dhparam.pem 4096
```

```bash
# VISIT
https://localhost:8443/
```

### BREEZE

```bash
cd src
docker run --rm --user 1000:1000 -v $PWD:/opt -w /opt composer:latest composer require laravel/breeze --dev
docker-compose exec laravel-php php artisan breeze:install
docker-compose exec laravel-php php artisan migrate
docker-compose exec laravel-php npm install
# restart vite
# docker-compose exec laravel-php npm run dev
```

## LIVEWIRE

```bash
docker run --rm --user 1000:1000 -v $PWD:/opt -w /opt composer:latest composer require livewire/livewire
```

```html
<html>
  <head>
    ... @livewireStyles
  </head>

  <body>
    ... @livewireScripts
  </body>
</html>
```

### TEST

TODO

### MIX INFO

- Fish Variables

  - `set -g UID (id -u)`
  - `set -g GID (id -g)`

- project create
  - `docker run --rm --user 1000:1000 -v $PWD:/opt -w /opt composer:latest composer create-project laravel/laravel <project>`
- breeze require (not required with filament)

  - `cd <project>`
  - `docker run --rm --user 1000:1000 -v $PWD:/opt -w /opt composer:latest composer require laravel/breeze --dev`

- breeze install
  - start container `docker-compose up -d`
  - `cd ..`
  - `docker-compose exec php php artisan breeze:install`
  - `docker-compose exec php npm install`
  - `docker-compose exec php npm run dev -- --host`
  - `docker-compose exec php php artisan migrate`
  - `docker-compose exec  php sh -c "chown -R 1000: * " `
  - `docker-compose exec  php sh -c "chmod  777 storage -R "`
  - add user migration `is_admin` boolean defaul false
- migrate
  - `docker-compose exec php php artisan migrate`
- seed

  - `docker-compose exec php php artisan make:seeder Admin`
  - `User::create(['name'=> 'Admin', 'email'=> 'admin@resto', 'password' => bcrypt('password'), 'is_admin' =>  true, 'remeber_token' => \Illuminate\Support\Str::random(10) ])`
  - `docker-compose exec php php artisan migrate:fresh --seed`

- middleware

  - `docker-compose exec php php artisan make:middleware Admin`
  - in Middleware logic: auth()->user()->is_admin && auth()->check() return 403
  - register Middleware in `kernel.php` routedMiddleware add `'admin' => \App\Http\Middleware\Admin::class`
  - route group in web.php

- view component
  - `docker-compose exec php php artisan make:component AdminLayout` ( ignore component admin-layout )
  - copy resources\views\appl.blade.php to admin.blade.php and point the Admin to this file
  - create view\admin\index.blade.php and use the new <x-admin-layout> ... ( copy logic from other files )

```php
<?php
Route::middleware(['auth', 'admin'],)
    ->name('admin.')
    ->prefix('admin')
    ->group(function () {
        Route::get('/', [AdminController::class, 'index'])->name('index');
    });
```

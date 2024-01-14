```bash
composer require filament/filament:"^3.1" -W --ignore-platform-reqs
```

The filament panel comes with pre-installed packages which we don't need to
install seperately (Form Builder, Table Builder, Notifications, Actions,
Infolists, and Widgets packages).

```bash
# install admin panel
php artisan filament:install --panels
# create first user
php artisan migrate
php artisan make:filament-user --name=admin --email=admin@example.com --password=password
```

### logo

```bash
mkdir -p resources/views/vendor/filament-panels/components/
touch resources/views/vendor/filament-panels/components/logo.blade.php
```

## VITE (not important till now)

[filament v3 development with vite and livewire hot reload](https://codingwisely.com/blog/enhancing-laravel-filament-v3-development-with-vite-and-livewire-hot-reload)

```bash
npm install -D tailwindcss postcss autoprefixer
npm tailwindcss init -p
```

```js
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./resources/**/*.blade.php", "./resources/**/*.js"],
  darkMode: "class",
  theme: {
    extend: {}
  },
  plugins: []
};
```

```js
// vite.config.js
import { defineConfig } from "vite";
import laravel, { refreshPaths } from "laravel-vite-plugin";

export default defineConfig({
  plugins: [
    laravel({
      input: ["resources/js/app.js"],
      refresh: [...refreshPaths, "app/Livewire/**", "app/Filament/**"]
    })
  ],
  server: {
    https: false,
    hmr: {
      host: "localhost"
    }
  }
});
```

```php
// Providers/Filament/AdminPanelProvider.php
use Filament\Support\Facades\FilamentView;
use Illuminate\Support\Facades\Blade;

public function register(): void
{
    parent::register();
    FilamentView::registerRenderHook('panels::body.end',
        fn(): string => Blade::render("@vite('resources/js/app.js')")
        );
}
```

```js
// resources/js/app.js
import "./bootstrap";
import "../css/app.css";
```

```css
/* resources/app/app.css */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

```js
// postcss.config.js
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {}
  }
};
```

## PINT

```bash
composer require laravel/pint --dev --ignore-platform-reqs
```

```bash
// pint.json

{
    "preset": "laravel",
    "rules": {
        "simplified_null_return": true,
        "braces": false,
        "array_indentation": true,
        "not_operator_with_space": true,
        "concat_space": true,
        "new_with_braces": {
            "anonymous_class": false,
            "named_class": false
        },
        "array_syntax": {
            "syntax": "short"
        },
        "binary_operator_spaces": {
            "default": "single_space",
            "operators": {
                "=>": "align"
            }
        },
        "no_unused_imports": true,
        "ordered_imports": {
            "sort_algorithm": "length"
        }
    }
}
```

```bash
// composer.json
 "scripts": {
        "pint": [
            "./vendor/bin/pint"
        ]
    },
```

## phpstan

```bash
composer require larastan/larastan --dev --ignore-platform-reqs
```

```bash
// phpstan.neon
includes:
    - ./vendor/larastan/larastan/extension.neon

parameters:

    paths:
        - app/

    level: 5
```

```bash
// composer.json
 "scripts": {
        "phpstan": [
            "./vendor/bin/phpstan"
        ]
    },
```

Это простой парсер для сбора информации о продуктах с веб-сайта Petsonic. Парсер собирает данные о названии продукта, цене и ссылке на изображение, а затем сохраняет эту информацию в файл CSV.

## Инструкции по установке и запуску
bundle install
ruby run.rb

Результаты будут сохранены в файле output.csv в формате:
title, price, image_url
Название продукта 1, Цена 1, Ссылка на изображение 1
Название продукта 2, Цена 2, Ссылка на изображение 2
...
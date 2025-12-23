# PipelinePractice
Пример [статус бейджа](https://docs.microsoft.com/en-us/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=java%2Ctfs-2018-2%2Cbrowser) с пайплайна:

[![Build Status](https://dev.azure.com/alekseevap/calculatorWebApi/_apis/build/status/antonaleks.calculatorWebApi?branchName=master)](https://dev.azure.com/alekseevap/calculatorWebApi/_apis/build/status/antonaleks.calculatorWebApi?branchName=master)

# Структура проекта
├── **guide**- *модуль с мануалом по заданию.*\
├── **entity**- *модуль сущностей.*\
│  ├── **calculator.py** - *класс Calculator, реализующий простые математические операции*\
├── **tests**- *модуль тестов.*\
│  ├── **functional_tests** - *модуль функциональных тестов*\
│  │  ├── **test_index.py** - *функциональные тесты с использованием фреймворка Selenium*\
│  │  ├── **yandexdriver.exe** - *драйвер для Selenium. Скачивается локально, в зависимости от браузера.* 
*Если используете yandexbrowser, драйвер можно скачать по [ссылке](https://github.com/yandex/YandexDriver/releases)* \
│  │  ├── **chromedriver.exe** - *драйвер для Selenium. Скачивается локально, в зависимости от браузера.* 
*Если используете chrome, драйвер можно скачать по [ссылке](https://chromedriver.chromium.org/downloads)* \
│  ├── **unit_tests** - *модуль юнит тестов*\
│  │  ├── **__init__.py** - *инициализация системного пути до модулей. Используется при запуске CI пайплайна (чтобы не ругался на путь к calculator.py).*\
│  │  ├── **test_calculator.py** - *юнит тесты класса Calculator*\
├── **azure-pipelines.yml**- *манифест запуска CI конвейера в репозитории Azure DevOps. Создается автоматически, заполняется на платформе Azure DevOps.*\
├── **requirements.txt**- *зависимости python.*\
├── **app.py**- *точка входа веб-приложения. Запускать через python app.py.*\

# Задание 1
1. Локально запустить юнит и функциональные тесты (либо написать такие же тесты с помощью curl/postman), свой сбилженный контейнер запускать через [сервисы](https://docs.gitlab.com/ee/ci/services/)
   2. если с curl то bash скрипт ( curl http://0.0.0.0:5000/multiply/2\&2)
   3. postman https://github.com/antonaleks/ya-praktikum-app/blob/a917aad29b4113a92fedb7eea95f39819286a4c0/backend/.gitlab-ci.yml#L48C1-L74C20
   4. selemium - https://github.com/webdriverio/selenium-standalone
2. В репозитории организовать конвейер CI с запуском Юнит тестов, упаковкой приложения в архив.
3. Установите раннер https://docs.gitflic.space/setup/runner_setup

# Задание 2
1. Реализовать деплой приложения, использя docker-compose файл
2. Реализовать стратегию деплоя - blue green. Пример взять [отсюда compose файл](https://github.com/antonaleks/ya-praktikum-app/blob/a917aad29b4113a92fedb7eea95f39819286a4c0/docker-compose.yml#L4) и [отсюда sh файл](https://github.com/antonaleks/ya-praktikum-app/blob/a917aad29b4113a92fedb7eea95f39819286a4c0/backend/deploy_blue_green.sh#L2)

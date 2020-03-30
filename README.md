# Ruptiva - Code Challenge Back-end

## Requisitos

Essa API é a resolução do teste de desenvolvimento Back-end proposto pela Ruptiva.
Para ver os requisitos do projeto: [Ruptiva - Code Challenge Back-end](https://github.com/ruptiva/Ruptiva-Code-Challenge-Back-end)

## Requisitos Técnicos

- Ruby 2.5.1
- Rails 5.2.4.2
- PostgreSQL 9.5.19

As `Gems` utilizadas são:

- [rails](https://github.com/rails/rails)
- [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth)
- [pundit](https://github.com/varvet/pundit)
- [rspec](https://github.com/rspec/rspec-rails)

## Pré-requisitos

### Postgres

O projeto utiliza o `postgres`. Para executar o projeto com sucesso, será necessário criar
um usuário chamado `ruptiva` com senha `ruptiva123` (a senha não é ocultada nesse projeto
pois será utilizado apenas no ambiente de desenvolvimneto).

No console do `postgres` use:

```
CREATE ROLE ruptiva WITH LOGIN PASSWORD 'ruptiva123';
```

Esse usuário deve possuir autorização para criar os bancos de dados:

```
ALTER ROLE ruptiva CREATEDB;
```

### RVM e Ruby 2.5.1

A versão do ruby utilizada no projeto é a 2.5.1. Para facilitar o gerenciamento de versões e bibliotecas do ruby entre o sistema, é recomendado utilizar o gerenciador de versões de ruby RVM.
Instale o rvm através da documentação: https://rvm.io/

Após ter o _rvm_ instalado, é possível instalar a versão 2.5.1:

```
rvm install 2.5.1
```

Após finalizar o rvm já poderá utilizar essa versão no projeto. O rvm consegue identificar automaticamente qual a versão que está sendo utilizada no projeto pelo arquivo `.ruby-version`, porém você pode alterar manualmente com o comando `rvm use 2.5.1`.

## Setup do projeto

### Gems

A primeira etapa é instalar todos os pacotes do Ruby, mas para isso será necessário instalar o bundler:

```
gem install bundler
```

Com o bundler instalado, instale todas as depdências do projeto:

```
bundle install
```

Esse comando irá instalar todas as depêndencias.

### Banco de dados

O arquivo de configuração de banco de dados para cada ambiente está localizado em `config/database.yml`. Nele é possível ver quais configurações vão ser utilizadas no banco de _develpment_ e _test_.
Tendo em vista que o usuário _ruptiva_ já foi criado na instalação do PostgreSQL, você pode executar o comando de criação e migração do banco com o _rake_:

```
rake db:create db:migrate
```

O dado inicial de seed pode ser adicionado com:

```
rake db:seed
```

O dado do seed é:

```
{
  "first_name": "Maikel",
  "last_name": "Bald",
  "email": "maikel@ruptiva.com",
  "password": "ilikeruptiva",
  "role": "admin"
}
```

## Rotas e funcionalidades

## Testes

Os testes devem ser executados utilizando [rspec](https://github.com/rspec/rspec-rails) e compreendem:

- Testes de Model: [spec/model](https://github.com/LeonardoEichs/ruptiva-code-challenge-backend/tree/master/spec/models)
- Testes de Request: [spec/requests](https://github.com/LeonardoEichs/ruptiva-code-challenge-backend/tree/master/spec/requests)

Para executar os testes com `rspec` use:

```
bundle exec rspec spec/models/ # Para executar testes de model
bundle exec rspec spec/requests/ # Para executar testes de request
bundle exec rspec # Para executar todos os testes
```

Se todos os testes passarem, a execução do comando deve resultar em algo similar à imagem abaixo:

![Execução dos testes](https://github.com/LeonardoEichs/ruptiva-code-challenge-backend/tree/master/readme-images/test-run.png)

Caso algum teste falhar, o `rspec` irá mostrar um aviso similar ao da imagem abaixo (apenas para ilustração):

![Execução dos testes com uma falha](https://github.com/LeonardoEichs/ruptiva-code-challenge-backend/tree/master/readme-images/failed-test-run.png)

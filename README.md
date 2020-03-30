# Ruptiva - Code Challenge Back-end

## Requisitos

Essa API é a resolução do teste de desenvolvimento Back-end proposto pela Ruptiva.
Para ver os requisitos do projeto:
[Ruptiva - Code Challenge Back-end](https://github.com/ruptiva/Ruptiva-Code-Challenge-Back-end)

## Requisitos Técnicos

- Ruby 2.5.1
- Rails 5.2.4.2
- PostgreSQL 9.5.19

As `Gems` utilizadas são:

- [rails](https://github.com/rails/rails)
- [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth)
- [pundit](https://github.com/varvet/pundit)
- [rspec](https://github.com/rspec/rspec-rails)

## Preparação do ambiente

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

O projeto consiste de uma RESTful JSON API em Ruby on Rails com CRUD de usuários, permissões e testes.

#### Permissões

- Usuários não autenticados não podem acessar qualquer informação
- Usuários `admin` tem acesso a todos registros
- Usuários `user` tem acesso somente ao seu próprio registro

#### Usuários

Suas funcionalidades consistem em:

- Permitir cadastro de usuário (não há necessidade de criação de um usuário por outro usuário)

Os usuários são cadastrados por meio de um `POST /users` tendo os dados do usuário como parâmetros no corpo da requisição
da seguinte maneira:

```
{
	"first_name": "Jon",
	"last_name": "Doe",
	"email": "jon@email.com",
	"password": "12345",
	"password_confirmation": "12345",
	"role": "admin"
}
```

O campo `first_name` e `last_name` representam o primeiro e segundo nome do usuário, respectivamente.

O campo `email` representa o e-mail do usuário e **será utilizado para fazer o sign in do usuário**.

O campo `password` representa a senha do usuário. Quando a senha for armazenada no banco de dados,
o `Devise` irá antes criptografar a senha passada pelo usuário e irá armazenar a senha criptografada no
campo `encrypted_password` do banco de dados. Isso garante maior segurança, evitando que as senhas dos
usuários possam ser vistas pelo acesso no banco de dados.

Esse é o comportamente padrão do `Devise`, caso quiséssemos quebrar esse protocolo de segurança e
permit que as senhas sejam vistas, seria necessário dar um override na função de criptografia do `devise`.

O campo `password_confirmation` deriva do comportamento de validação especificado no model de `User`, portanto
ele não existe como um campo do banco de dados. É necessário preencher esse campo com o mesmo valor que o
passado para `password`.

O campo `role` especifica o papel do usuário, sendo eles `[user, admin]`. Por padrão, o usuário criado
possui `role: "user"`, portanto se esse campo não for explicitamente definido, o usuário será criado com
o comportamento padrão.

O `role` como `user` limita os dados acessíveis pelo usuário, permitindo que ele tenha acesso apenas a certos
campos e que só possa visualizar/alterar a si mesmo. O `admin`, por outro lado, pode ver todos os dados
dos usuários, assim como visualizar/alterar tanto a si mesmo como qualquer outro usuário cadastrado.

- Permitir login através de `email` e `password`

O login é feito por meio de um `POST /auth/sign_in`, tendo o `email` e `password` de um usuário como
parâmetros no corpo da requisição da seguinte maneira:

```
{
	"email": "jon@email.",
	"password": "12345"
}
```

**Obs:** não é permitido fazer o login em uma conta que esteja marcada como deletada.

O resultado do `sign_in` deve ser um `Status: 200 OK` e nos `Headers` da resposta teremos:

![Headers após sign_in](/readme-images/sign_in.png?raw=true)

Os campos importantes desse `Header` são:

- **access-token**
- **client**
- **uid**

**Para fazer requisições utilizando um usuário logado, será necessário colocar esses campos, assim como seus respectivos valores, no Headers da requisição:**

![Headers da requisição com usuário logado](/readme-images/request_header.png?raw=true)

- Permitir listar usuários

Os usuários são listados por meio de um `GET /users`.

![GET /users](/readme-images/list_request.png?raw=true)

Caso esteja cadastrado como um usuário com `role` como `user` os dados acessíveis pelo usuário são limitados,
permitindo que ele tenha acesso apenas a certos campos e que só possa visualizar a si mesmo.

Caso esteja como `admin`, por outro lado, pode ver todos os dados dos usuários, assim como visualizar todos
os usuários cadastrados (inclusive os marcados como deletados).

![GET /users Result](/readme-images/result.png?raw=true)

- Permitir visualização de usuário

Os usuários são listados por meio de um `GET /users/:id`.

![GET /users/:id](/readme-images/show_request.png?raw=true)

Caso esteja cadastrado como um usuário com `role` como `user` os dados acessíveis pelo usuário são limitados,
permitindo que ele tenha acesso apenas a certos campos e que só possa visualizar a si mesmo.

Caso esteja como `admin`, por outro lado, pode ver todos os dados dos usuários, assim como visualizar todos
os usuários cadastrados (inclusive os marcados como deletados).

![GET /users/:id Result](/readme-images/show_result.png?raw=true)

- Permitir update de usuários

Os usuários são atualizado por meio de um `PUT /users/:id`, tendo os dados do usuário a serem atualizados
como parâmetros no corpo da requisição da seguinte maneira:

![PUT /users/:id](/readme-images/put_request.png?raw=true)

Ex: mudar `first_name`

```
{
	"first_name": "Bob"
}
```

![PUT /users/:id Result](/readme-images/put_result.png?raw=true)

Caso esteja cadastrado como um usuário com `role` como `user` os dados acessíveis pelo usuário são limitados,
permitindo que ele tenha acesso apenas a certos campos e que só possa atualizar a si mesmo.

Dados que podem ser alterados por `user`:

```
{
    first_name,
    last_name,
    email
}
```

Caso esteja como `admin`, por outro lado, pode atualizar mais dados dos usuários, assim como atualizar todos
os usuários cadastrados.

Dados que podem ser alterados por `admin`:

```
{
    id,
    provider,
    first_name,
    last_name,
    role,
    deleted,
    created_at,
    updated_at
}
```

- Permitir exclusão de usuário por soft-delete

Os usuários são deletados por meio de um `DEL /users/:id`.

![DEL /users/:id](/readme-images/delete_request.png?raw=true)

Caso esteja cadastrado como um usuário com `role` como `user` só é permitido
que ele delete a si mesmo.

Caso esteja como `admin`, por outro lado, pode deletar qualquer um dos
usuários cadastrados.

![DEL /users/:id Result](/readme-images/delete_result.png?raw=true)

O comportamento do soft-delete é marcar o campo `deleted` como `true` e apagar o `token`
de acesso do usuário deletado.

Dessa forma, não será mais possível fazer nenhuma ação utilizando o usuário que foi
deletado, nem mesmo fazer um novo `sign in` passando os dados do usuário deletado.

![Sign in deleted](/readme-images/sign_in_deleted.png?raw=true)

Os dados do usuário deletado se mantém no banco de dados e este pode ser reativado por meio
de um `admin` atualizando a opção deleted como `false` e, após isso, fazer um novo `sign in`.

Obs: Não será possível cadastrar um novo usuário utilizando um email de uma conta já cadastrada,
mesmo que essa conta esteja marcada como `deleted: true`.

## Testes

Os testes devem ser executados utilizando [rspec](https://github.com/rspec/rspec-rails) e compreendem:

- Testes de Model: [spec/model](/spec/models)
- Testes de Request: [spec/requests](/spec/requests)

Para executar os testes com `rspec` use:

```
bundle exec rspec spec/models/ # Para executar testes de model
bundle exec rspec spec/requests/ # Para executar testes de request
bundle exec rspec # Para executar todos os testes
```

Se todos os testes passarem, a execução do comando deve resultar em algo similar à imagem abaixo:

![Execução dos testes](/readme-images/test-run.png?raw=true)

Caso algum teste falhar, o `rspec` irá mostrar um aviso similar ao da imagem abaixo (apenas para ilustração):

![Execução dos testes com uma falha](/readme-images/failed-test-run.png?raw=true)

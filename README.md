# API Endpoints

## Public Endpoints

### Login

#### POST: /auth/login

##### Returns user's access data

```json
{
  "email": "String",
  "password": "String"
}
```

Response:

```json
{
  "token": "String",
  "exp": "String",
  "email": "String"
}
```

### Register

#### POST: /register

##### Creates new User

```json
{
  "email": "String",
  "name": "String",
  "password": "String",
  "password_confirmation": "String"
}
```

Response:

```json
{
  "name": "String",
  "email": "String",
  "slug": "String",
  "role": "String"
}
```

## Admin Endpoints

All requests must have:

```json
{
  "headers": {
    "Authorization": "String with admin's access token"
  }
}
```

### Users

#### GET: /admin/users

##### Show all Users

Response:

```json
[
  {
    "name": "String",
    "email": "String",
    "slug": "String",
    "role": "String"
  }
]
```

#### GET: /admin/users/[slug]

##### Show given User

Response:

```json
{
  "name": "String",
  "email": "String",
  "slug": "String",
  "role": "String"
}
```

#### PUT: /admin/users/[slug]

##### Update given User

```json
{
  "name": "String",
  "password": "String",
  "password_confirmation": "String",
  "email": "String",
  "role": "String" // Available Options: "user" and "admin"
}
```

Response:

```json
{
  "message": "String"
}
```

#### DESTROY: /admin/users/[slug]

##### Destroy given User

Response:

```json
{
  "message": "String"
}
```

## User Endpoints

All Requests are related to User
All requests must have:

```json
{
  "headers": {
    "Authorization": "String" // JWT-Token for any User
  }
}
```

### Default Bills

#### GET: /default_bills

##### Find all Default Bills

Response:

```json
[
  {
    "name": "String",
    "slug": "String",
    "value_in_cents": "Integer"
  }
]
```

#### POST: /default_bills

##### Create Default Bill

```json
{
  "name": "String",
  "value_in_cents": "Integer"
}
```

Response:

```json
{
  "message": "String"
}
```

#### GET: /default_bills/[slug]

##### Show given Default Bill

Response:

```json
{
  "name": "String",
  "slug": "String",
  "value_in_cents": "Integer"
}
```

#### POST: /default_bills/[slug]

##### Update given Default Bill

```json
{
  "name": "String",
  "value_in_cents": "Integer"
}
```

Response:

```json
{
  "message": "String"
}
```

#### DESTROY: /default_bills/[slug]

##### Destroy given Default Bill

Response:

```json
{
  "message": "String"
}
```

### Accounts

#### GET: /accounts

##### Find all Accounts

Response:

```json
[
  {
    "name": "String",
    "slug": "String",
  }
]
```

#### POST: /accounts

##### Create Account

```json
{
  "name": "String",
}
```

Response:

```json
{
  "message": "String"
}
```

#### GET: /accounts/[slug]

##### Show given Account

Response:

```json
{
  "name": "String",
  "slug": "String",
  "value_in_cents": "Integer"
}
```

#### POST: /accounts/[slug]

##### Update given Account

```json
{
  "name": "String",
}
```

Response:

```json
{
  "message": "String"
}
```

#### DESTROY: /accounts/[slug]

##### Destroy given Account

Response:

```json
{
  "message": "String"
}
```

### Categories

#### GET: /categories

##### Find all Categories

Response:

```json
[
  {
    "name": "String",
    "slug": "String",
  }
]
```

#### POST: /categories

##### Create Category

```json
{
  "name": "String",
}
```

Response:

```json
{
  "message": "String"
}
```

#### GET: /categories/[slug]

##### Show given Category

Response:

```json
{
  "name": "String",
  "slug": "String",
  "value_in_cents": "Integer"
}
```

#### POST: /categories/[slug]

##### Update given Category

```json
{
  "name": "String",
}
```

Response:

```json
{
  "message": "String"
}
```

#### DESTROY: /categories/[slug]

##### Destroy given Category

Response:

```json
{
  "message": "String"
}
```

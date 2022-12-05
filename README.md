# API Endpoints

## Authentication

### No user required

#### Register new user

##### POST: /users

```json
params: {
  name: 'string'
  email: 'string'
  password: 'string'
  password_confirmation: 'string'
}
```

#### Login user

##### POST: /auth/login

```json
params: {
  email: 'string'
  password: 'string'
}
```

## Users

### Admin user

#### Get all Users

##### GET: /admin/users

```json
headers: {
  Authorization: 'jwt-token'
}
```

#### Get user

##### GET: /admin/users/{slug}

```json
headers: {
  Authorization: 'jwt-token'
}
```

#### Update user

##### PATCH: /admin/users/{slug}

```json
headers: {
  Authorization: 'jwt-token'
},
params: {
  email: 'string'
}
```

#### Destroy user

##### DELETE: /admin/users/{slug}

```json
headers: {
  Authorization: 'jwt-token'
}
```

## Accounts

### Normal user

#### Get all user accounts

##### GET: /accounts

```json
headers: {
  Authorization: 'jwt-token'
},

params: {
  user_id: 'integer'
}
```

#### Get user account

##### GET: /accounts/{slug}

```json
headers: {
  Authorization: 'jwt-token'
}
```

#### Create user account

##### POST: /accounts

```json
headers: {
  Authorization: 'jwt-token'
},
params: {
  user_id: 'integer',
  name: 'string'
}
```

#### Update user account

##### PUT: /accounts/{slug}

```json
headers: {
  Authorization: 'jwt-token'
},
params: {
  user_id: 'integer',
  name: 'string'
}
```

#### Destroy user account

##### DELETE: /accounts/{slug}

```json
headers: {
  Authorization: 'jwt-token'
}
```

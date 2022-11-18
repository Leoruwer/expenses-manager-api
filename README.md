# API Endpoints

### Create Users
###### POST: /users
```
{
  name: 'string'
  email: 'string'
  password: 'string'
  password_confirmation: 'string'
}
```

### Login
###### POST: /auth/login
```
{
  email: 'string'
  password: 'string'
}
```
### Get all Users
###### GET: /users
```
headers: {
  Authorization: 'jwt-token'
}
```
### Get user
###### GET: /users/{slug}

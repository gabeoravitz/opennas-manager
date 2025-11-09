# API Documentation

## Base URL

```
http://localhost:3001/api
```

## Authentication

All endpoints (except `/auth/login`) require JWT token in Authorization header:

```
Authorization: Bearer <token>
```

## Endpoints

### Authentication

#### POST /auth/login
Login with username and password.

**Request:**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**Response:**
```json
{
  "user": {
    "id": "uuid",
    "username": "admin",
    "email": "admin@example.com",
    "role": "admin"
  },
  "token": "jwt_token"
}
```

#### POST /auth/logout
Logout current user.

#### GET /auth/me
Get current user info.

### Users

#### GET /users
List all users.

#### POST /users
Create new user.

#### GET /users/:id
Get user by ID.

#### PATCH /users/:id
Update user.

#### DELETE /users/:id
Delete user.

### Files

#### GET /files
List files in directory.

#### POST /files/upload
Upload file.

#### GET /files/:id/download
Download file.

#### DELETE /files/:id
Delete file.

### Storage

#### GET /storage/pools
List storage pools.

#### POST /storage/pools
Create storage pool.

#### GET /storage/volumes
List volumes.

#### POST /storage/volumes
Create volume.

See Swagger docs at `/api/docs` for complete API reference.


let Config = ../../services/backend/config.dhall


in
{ database = {
        host = "localhost",
        port = 5432,
        user = "backend_user",
        password = "backend_password",
        database = "backend_db"
      }
, messaging = {
      host = "localhost",
      port = 5672,
      user = "guest",
      password = "guest",
      vhost = "/"
  }
, cache = {
      host = "localhost",
      port = 6379,
      password = None Text
  }
, auth = {
      jwt_secret = "default_jwt_secret",
      jwt_expiration = 3600,
      refresh_secret = "default_refresh_secret",
      refresh_expiration = 86400
  }
, smtp = {
      host = "smtp.example.com",
      port = 587,
      user = "noreply@example.com",
      password = "smtp_password",
      from = "noreply@example.com"
  }
}: Config

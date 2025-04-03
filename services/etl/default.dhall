let generateMongoURI = ./../../common/functions/mongo.dhall
let Config = ../../services/etl/config.dhall

in
{ postgres ={
        host = "localhost",
        port = 5432,
        user = "etl_user",
        password = "etl_password",
        database = "etl_db"
      }
    , mongo = generateMongoURI {
        host = "localhost",
        port = 27017,
        user = "mongo_user",
        password = "mongo_password",
        database = "etl_db",
        replicaSet = Some "rs0"
      }
, messaging = {
      host = "localhost",
      port = 5672,
      user = "guest",
      password = "guest",
      vhost = "/"
  }
}

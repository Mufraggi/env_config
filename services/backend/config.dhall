let Postgres = ../../common/types/postgres.dhall
let Mongo = ../../common/types/mongo.dhall
let Messaging = ../../common/types/messaging.dhall
let Cache = ../../common/types/cache.dhall
let Auth = ../../common/types/auth.dhall
let SMTP = ../../common/types/smtp.dhall

let Config : Type =
      { database : Postgres
      , messaging : Messaging
      , cache : Cache
      , auth : Auth
      , smtp : SMTP
      }: Type
in Config
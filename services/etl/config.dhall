let Postgres = ../../common/types/postgres.dhall
let Messaging = ./../../common/types/messaging.dhall


let Config : Type =
      { postgres : Postgres
      , mongo : Text
      , messaging : Messaging
      } in Config
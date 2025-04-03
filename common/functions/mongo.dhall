let MongoConfig = ../types/mongo.dhall

let Optional/fold = https://prelude.dhall-lang.org/Optional/fold

let generateMongoURI
    : MongoConfig → Text
    = λ(config : MongoConfig) →
      let base = "mongodb://" ++ config.user ++ ":" ++ config.password ++ "@"
                 ++ config.host ++ ":" ++ Natural/show config.port ++ "/"
                 ++ config.database

      in  Optional/fold
            Text
            config.replicaSet
            Text
            (λ(replica : Text) → base ++ "?replicaSet=" ++ replica)
            base

in  generateMongoURI

let MongoConfig = ../types/mongo.dhall

let Optional/fold =
      https://prelude.dhall-lang.org/Optional/fold
        sha256:c5b9d72f6f62bdaa0e196ac1c742cc175cd67a717b880fb8aec1333a5a4132cf

let generateMongoURI
    : MongoConfig → Text
    = λ(config : MongoConfig) →
        let base =
                  "mongodb://"
              ++  config.user
              ++  ":"
              ++  config.password
              ++  "@"
              ++  config.host
              ++  ":"
              ++  Natural/show config.port
              ++  "/"
              ++  config.database

        in  Optional/fold
              Text
              config.replicaSet
              Text
              (λ(replica : Text) → base ++ "?replicaSet=" ++ replica)
              base

in  generateMongoURI

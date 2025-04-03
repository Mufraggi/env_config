let MongoConfig =
    { host : Text
    , port : Natural
    , user : Text
    , password : Text
    , database : Text
    , replicaSet : Optional Text
    }: Type

in MongoConfig
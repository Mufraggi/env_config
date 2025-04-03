let AuthConfig =
        { jwt_secret : Text
        , jwt_expiration : Natural
        , refresh_secret : Text
        , refresh_expiration : Natural
        }
      : Type

in  AuthConfig

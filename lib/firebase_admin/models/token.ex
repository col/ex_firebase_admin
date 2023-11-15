defmodule FirebaseAdmin.Models.Token do
  defstruct [
    :expiresIn,
    :idToken,
    :isNewUser,
    :kind,
    :refreshToken
  ]
end

defmodule FirebaseAdmin.Token do
  use Joken.Config

  def token_config, do: default_claims(default_exp: 60 * 60) # 1 hour
end
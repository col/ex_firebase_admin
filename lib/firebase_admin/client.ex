defmodule FirebaseAdmin.Client do
  use Tesla
  alias FirebaseAdmin.Token

  def get_users(uid) do
    get_users_with(:localId, uid)
  end

  def get_user_with_phone(phone) do
    get_users_with(:phoneNumber, phone)
  end

  def get_user_with_email(email) do
    get_users_with(:email, email)
  end

  def get_users_with(key, value) do
    post(client(), "v1/accounts:lookup", %{key => value})
  end

  def custom_token(uid, service_account) do
    payload = %{
      "iss" => service_account.client_email,
      "sub" => service_account.client_email,
      "aud" =>
        "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
      "uid" => uid
    }

    signer = Joken.Signer.create("RS256", %{"pem" => service_account.private_key})
    Token.generate_and_sign!(payload, signer)
  end

  def sign_in_with_custom_token(token) do
    post(client(), "v1/accounts:signInWithCustomToken", %{token: token, returnSecureToken: true})
  end

  def client() do
    {:ok, token} = Goth.fetch(FirebaseAdmin.Goth)

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://identitytoolkit.googleapis.com/"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token.token}]}
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 10_000]}

    Tesla.client(middleware, adapter)
  end
end

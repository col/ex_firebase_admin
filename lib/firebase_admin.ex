defmodule FirebaseAdmin do
  alias FirebaseAdmin.Client
  alias FirebaseAdmin.Models.{User, ProviderInfo, Token}

  def get_user(uid) do
    case get_users_with(:localId, uid) do
      {:ok, users} -> {:ok, List.first(users)}
      error -> error
    end
  end

  def get_users_with_phone(phone) do
    get_users_with(:phoneNumber, phone)
  end

  def get_users_with_email(email) do
    get_users_with(:email, email)
  end

  def token_for_user(%User{localId: uid}) when is_binary(uid) do
    token_for_user(uid)
  end

  def token_for_user(uid) do
    case uid |> Client.custom_token() |> Client.sign_in_with_custom_token() do
      {:ok, %{status: 200, body: body}} ->
        parse_token(body)
      error ->
        parse_error(error)
    end
  end

  defp get_users_with(key, value) do
    case Client.get_users_with(key, value) do
      {:ok, %{status: 200, body: body}} ->
        parse_users(body["users"])
      error ->
        parse_error(error)
    end
  end

  defp parse_users(nil), do: {:ok, []}

  defp parse_users(users) do
    users = Poison.Decode.transform(users, %{as: [%User{providerUserInfo: [%ProviderInfo{}]}]})
    {:ok, users}
  end

  defp parse_token(body) do
    token = Poison.Decode.transform(body, %{as: %Token{}})
    {:ok, token}
  end

  defp parse_error(error = {:error, _}), do: error

  defp parse_error(error = {:ok, %{body: body}}) do
    message = body
      |> Map.get("error", %{})
      |> Map.get("message", "unknown error")
    {:error, message}
  end
end

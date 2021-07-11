# FirebaseAdmin

Client library to access Firebase admin features.

## Usage

```shell
#
# Lookup users by id
#
{:ok, user} = FirebaseAdmin.get_user("<uid>")
> {:ok,
 %FirebaseAdmin.Models.User{
   createdAt: "1611739689446",
   customAttributes: "",
   customAuth: true,
   displayName: "Joe Armstrong",
   email: "joe.armstrong@erlang.org",
   emailVerified: true,
   lastLoginAt: "1625890143092",
   lastRefreshAt: "2021-07-10T04:09:03.092Z",
   localId: "xxxxxxxxxxxxxxxxxxxxxxxxxxxx",
   passwordHash: "xxxxxxxxxxxx=",
   passwordUpdatedAt: 1624928169397,
   photoUrl: "https://www.example.com",
   providerUserInfo: [
     %FirebaseAdmin.Models.ProviderInfo{
       displayName: "Joe Armstrong",
       email: "joe.armstrong@erlang.org",
       federatedId: "100000000000000000000",
       photoUrl: "https://www.example.com",
       providerId: "google.com",
       rawId: "100000000000000000000"
     },
     %FirebaseAdmin.Models.ProviderInfo{
       displayName: "Joe Armstrong",
       email: "joe.armstrong@erlang.org",
       federatedId: "joe.armstrong@erlang.org",
       photoUrl: "https://www.example.com",
       providerId: "password",
       rawId: "joe.armstrong@erlang.org"
     }
   ],
   validSince: "1624928169"
 }}

# Or phone or email
{:ok, user} = FirebaseAdmin.get_users_with_phone("<phone>")
{:ok, user} = FirebaseAdmin.get_users_with_email("<email>")

#
# Generate id tokens
#
{:ok, token} = FirebaseAdmin.token_for_user(user)
# or
{:ok, token} = FirebaseAdmin.token_for_user("<uid>")
 > {:ok,
 %FirebaseAdmin.Models.Token{
   expiresIn: "3600",
   idToken: "eyJhbGci...xoRChITw",
   isNewUser: false,
   kind: "identitytoolkit#VerifyCustomTokenResponse",
   refreshToken: "AGEhc0Av...xTTnNHW"
 }}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `firebase_admin` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:firebase_admin, "~> 0.1.0"}
  ]
end
```

## Configuration

Add `Goth` to your supervision tree. Example:
```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    service_account = System.fetch_env!("GOOGLE_APPLICATION_CREDENTIALS") |> File.read!() |> Jason.decode!()
    children = [
      {Goth, name: FirebaseAdmin.Goth, source: {:service_account, service_account, []}}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
```

See the [Goth repo](https://github.com/peburrows/goth/tree/master) for more info. 
**Note:** FirebaseAdmin currently uses HEAD version of Goth in preparation for the v1.3.0 release.


defmodule FirebaseAdmin.Models.User do
  defstruct [
    :createdAt,
    :customAttributes,
    :customAuth,
    :displayName,
    :email,
    :emailVerified,
    :lastLoginAt,
    :lastRefreshAt,
    :localId,
    :passwordHash,
    :passwordUpdatedAt,
    :photoUrl,
    :providerUserInfo,
    :validSince
  ]
end

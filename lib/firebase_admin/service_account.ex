defmodule FirebaseAdmin.ServiceAccount do
  defstruct [:project_id, :private_key, :client_email]

  def new(project_id, private_key, client_email) do
    %__MODULE__{project_id: project_id, private_key: private_key, client_email: client_email}
  end

  def from_file(file_path) do
    file_path
      |> File.read!()
      |> Jason.decode!(as: __MODULE__, keys: :atoms)
  end

  def from_goth() do
    credentials()
    |> Poison.Decode.transform(%{as: %__MODULE__{}})
  end

  defp credentials() do
    case get_goth_config(using_registry()) do
      %{source: {:service_account, credentials, _}} -> credentials
      _ -> %{}
    end
  end

  defp get_goth_config(true) do
    # Goth Version > v1.3.0-rc.2
    [{_pid, {config, _token}}] = Registry.lookup(Goth.Registry, FirebaseAdmin.Goth)
    config
  end

  defp get_goth_config(false) do
    # Goth Version <= v1.3.0-rc.2
    {config, _token} = :ets.lookup_element(FirebaseAdmin.Goth, :data, 2)
    config
  end

  defp using_registry() do
    try do
      String.to_existing_atom(Goth.Registry)
      true
    rescue
      ArgumentError -> false
    end
  end
end

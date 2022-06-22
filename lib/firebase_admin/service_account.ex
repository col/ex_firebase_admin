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

  def credentials(service_account) do
    service_account
    |> Jason.encode!
    |> Jason.decode!
  end
end

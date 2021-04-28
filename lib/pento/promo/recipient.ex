defmodule Pento.Promo.Recipient do
  defstruct [:first_name, :email]

  import Ecto.Changeset

  @valid_types %{first_name: :string, email: :string}

  def changeset(%__MODULE__{} = user, attrs) do
    {user, @valid_types}
    |> cast(attrs, Map.keys(@valid_types))
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end

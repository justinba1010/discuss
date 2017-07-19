defmodule Discuss.Comment do
  use Discuss.Web, :model

  schema "comments" do
    field :content, :string
    belongs_to :topic, Discuss.Topic
    belongs_to :user, Discuss.User
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :topic_id, :user_id])
    |> validate_required([:content])
  end
end

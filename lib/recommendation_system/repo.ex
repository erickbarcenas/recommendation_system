defmodule RecommendationSystem.Repo do
  alias Bolt.Sips, as: Neo
  def users_list do
    cypher = """
              MATCH (u:User)
              RETURN u.uid AS uid, u.name AS name
            """
    case Neo.query(Neo.conn(), cypher) do
      {:ok,  %Bolt.Sips.Response{results: results}} -> 
        results 
        |> Enum.map(fn user -> 
          %{
            uid: user["uid"],
            name: user["name"],
            gender: user["gender"]
          }
         end)
      {:error, response} -> response.message
    end
  end
end

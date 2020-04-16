defmodule Lab2Web.Lab2Channel do
  use Lab2Web, :channel
  import Ecto.Query
  use Ecto.Schema
  alias Lab2.Repo, as: Repo

  def join("lab2:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("get:tables",_payload,socket) do
    # query = from r in "#{payload["message"]}",
    #         select: r.id,r.name
    query1 = from u in "authors",
          select: [u.id,u.name,u.surname]
    query2 = from u in "genres",
          select: [u.id,u.name]
    query3 = from n in "publishers",
          select: [n.id,n.name]
    Enum.map(Repo.all(query1), fn([id,name,surname])-> [id,name<>" "<>surname] end)
    |>(&broadcast(socket, "tables:answer", %{authors: &1,genres: Repo.all(query2),publishers: Repo.all(query3)})).()
    # IO.inspect(Repo.all(query1)++Repo.all(query2)++Repo.all(query3))
    {:noreply, socket}
  end

  def handle_in("submit:manga",payload,socket) do
    {a_id,_} = Integer.parse(payload["author_id"])
    {g_id,_} = Integer.parse(payload["genre_id"])
    {p_id,_} = Integer.parse(payload["publisher_id"])
    {score,_} = Integer.parse(payload["score"])
    case Repo.insert %Lab2.Mangas.Manga{author_id: a_id,genre_id: g_id, publisher_id: p_id,score: score} do
      {:ok, struct} -> struct
      {:error, changeset} -> changeset
    end
    {:noreply,socket}
  end

  def handle_in("manga:search",payload,socket) do
    score = if(payload["score"] != "", do: payload["score"], else: "*")
    author = if(payload["author"] != "", do: payload["author"], else: "*")
    publisher = if(payload["publisher"] != "", do: payload["publisher"], else: "*")
    genre = if(payload["genre"] != "", do: payload["genre"], else: "*")
    query = from n in "mangas",
      select: [n.id,n.score,n.author_id,n.publisher_id,n.genre_id]
    IO.inspect(Repo.all(query))
    #broadcast(socket,"manga:found", %{anwser: Repo.all(query)})
    {:noreply,socket}
  end

  def handle_id("author:search",payload,socket) do
    {:noreply,socket}
  end

  def handle_id("genre:search",payload,socket) do
    {:noreply,socket}
  end

  def handle_id("publ:search",payload,socket) do
    {:noreply,socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (lab2:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

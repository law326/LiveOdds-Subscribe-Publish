defmodule LiveOdds.PubSub do
  use GenServer

  def start_link() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end
  
  def init(_args) do
    {:ok, %{}}
  end
  
  def publish(topic, msg) do
    GenServer.cast(__MODULE__, {:publish, topic, msg})
  end

  def subscribe(topic) do
    GenServer.cast(__MODULE__, {:subscribe, topic, self})
  end

  def subscribers(topic) do
    GenServer.call(__MODULE__, {:subscribers, topic})
  end

  def unsubscribe(topic) do
    GenServer.call(__MODULE__, {:unsubscribe, topic, self})
  end

  def topics() do
    GenServer.call(__MODULE__, :topics)
  end

  def handle_cast({:publish, topic, msg}, _, subscribers) do
    topic_subscribers = Map.get(subscribers, topic)
    Enum.map(topic_subscribers, fn(subscriber) -> send(subscriber, msg) end)
    {:noreply, subscribers}
  end
  
  def handle_cast({:subscribe, topic, pid}, subscribers) do
    case Map.fetch(subscribers, topic) do
      {:ok, topic_subscribers} ->
        subscribers = Map.put(subscribers, topic, List.flatten([topic_subscribers|[pid]]))
      :error -> 
        subscribers = Map.put(subscribers, topic, [pid])
    end
    {:noreply, subscribers}
  end

  def handle_call({:subscribers, topic}, _, subscribers) do
    {:reply, Map.get(subscribers, topic), subscribers}
  end

  def handle_call({:unsubscribe, topic, pid}, _, subscribers) do
    case Map.fetch(subscribers, topic) do
      {:ok, topic_subscribers} ->
        subscribers = Map.put(subscribers, topic, List.delete(topic_subscribers, pid))
      :error -> 
        IO.inspect "Not subscribed."
    end
    {:reply, subscribers, subscribers}
  end

  def handle_call(:topics, _, subscribers) do
    {:reply, Map.keys(subscribers), subscribers}
  end
end

defmodule LiveOddsTest do
  use ExUnit.Case
  alias LiveOdds.PubSub, as: PubSub

  test "it should subscribe topic" do
    PubSub.start_link

    assert :ok == PubSub.subscribe(:abc)
    assert [self] == PubSub.subscribers(:abc)
  end

  test "it should show topic subscribers" do
    PubSub.start_link

    assert :ok == PubSub.subscribe(:abc)
    assert [self] == PubSub.subscribers(:abc)
  end

  test "it should unsubscribe topic from subscriber" do
    PubSub.start_link

    assert :ok == PubSub.subscribe(:abc)
    assert %{abc: []} == PubSub.unsubscribe(:abc)
    assert [] == PubSub.subscribers(:abc)
  end

  test "it should show topics" do
    PubSub.start_link

    assert :ok == PubSub.subscribe(:abc)
    assert :ok == PubSub.subscribe(:bbc)
    assert :ok == PubSub.subscribe(:cnn)
    assert [:abc, :bbc, :cnn] == PubSub.topics
  end

end

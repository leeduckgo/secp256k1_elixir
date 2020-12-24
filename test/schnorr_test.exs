defmodule Secp256k1.SchnorrTest do
  alias Secp256k1.{Schnorr, Utils}
  use ExUnit.Case

  @doc """
    Purpose: to make sure schnorr alg is same as python-sdk
  """
  test "Schnorr.generate_signature/3" do
    data = get_test_data()

    Enum.reduce(data, 0, fn item, acc ->
      IO.puts("run case no_#{acc}")
      assert Schnorr.generate_signature(item.priv, item.msg, item.k) == item.sig
      acc + 1
    end)
  end

  def get_test_data() do
    {:ok, body} = get_json("test/schnorr.json")

    Enum.map(body, fn item ->
      item
      |> to_atom_struct()
      |> format_data()
    end)
  end

  defp get_json(filename) do
    with {:ok, body} <- File.read(filename), {:ok, json} <- Poison.decode(body), do: {:ok, json}
  end

  defp to_atom_struct(struct) do
    for {key, val} <- struct, into: %{}, do: {String.to_atom(key), val}
  end

  defp format_data(%{k: k, msg: msg, priv: priv, r: r, s: s}) do
    k_formatted = String.to_integer(k, 16)
    msg_formatted = Base.decode16!(msg)
    priv_formatted = Base.decode16!(priv)
    sig_formatted = hex_to_bin(r) <> hex_to_bin(s)

    %{
      k: k_formatted,
      msg: msg_formatted,
      priv: priv_formatted,
      sig: sig_formatted
    }
  end

  defp hex_to_bin(hex) do
    hex
    |> String.to_integer(16)
    |> Utils.int_to_bytes(32)
  end
end

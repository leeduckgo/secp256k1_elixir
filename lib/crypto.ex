defmodule Secp256k1.Crypto do
  def sha256(data), do: :crypto.hash(:sha256, data)
end

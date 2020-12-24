defmodule Secp256k1.Utils do
  alias Secp256k1.Binary

  @doc """
  calculate rem(a, b) as a%b in python
  """
  def calculate_rem(a, b) do
    a - b * floor_div(a, b)
  end

  def floor_div(a, b) when a >= 0 and b >= 0 do
    Kernel.div(a, b)
  end

  def floor_div(a, b) when a < 0 and b >= 0 do
    case Kernel.rem(a, b) do
      0 ->
        Kernel.div(a, b)

      _ ->
        Kernel.div(a, b) - 1
    end
  end

  def floor_div(a, b) do
    floor_div(-a, -b)
  end

  ## === int to bytes ===
  @doc """
    same as a.to_bytes(length = n, byteorder = "big") in Python
  """
  def int_to_bytes(number, the_length \\ 0) do
    # int to bytes
    the_result = :binary.encode_unsigned(number)
    # pad zero to complete
    if the_length > 0 do
      Binary.pad(the_result, the_length, :left)
    else
      the_result
    end
  end
end

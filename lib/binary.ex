defmodule Secp256k1.Binary do
  use Bitwise

  @doc """
  Returned a binary padded to given length in bytes. Fails if
  binary is longer than desired length.
  """
  @spec pad(binary(), integer()) :: binary()
  def pad(binary, desired_length, direction \\ :left) do
    desired_bits = desired_length * 8

    case byte_size(binary) do
      0 ->
        <<0::size(desired_bits)>>

      x when x <= desired_length ->
        padding_bits = (desired_length - x) * 8

        case direction do
          :left -> <<0::size(padding_bits)>> <> binary
          :right -> binary <> <<0::size(padding_bits)>>
        end

      _ ->
        raise "Binary too long for padding"
    end
  end
end

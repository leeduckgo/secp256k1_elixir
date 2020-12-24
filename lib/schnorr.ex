defmodule Secp256k1.Schnorr do
  alias Secp256k1.{Crypto, Point, Secp256k1Generator, Utils}
  import Secp256k1.Utils, only: [calculate_rem: 2]

  require Bitwise

  @g_point Secp256k1Generator.new()
  @encode_size 32

  ## === sign_transaction ===
  def sign(priv, payload) do
    k = generate_k()
    generate_signature(priv, payload, k)
  end

  ## === sub funcs of sign ===
  @doc """
    same as sign in js-sdk,  which secp256k1.curve.n == order:
    https://github.com/Zilliqa/Zilliqa-JavaScript-Library/blob/dev/packages/zilliqa-js-crypto/src/schnorr.ts
  """
  @spec generate_k :: integer()
  def generate_k() do
    order = @g_point.order
    :rand.uniform(order - 1)
  end

  @doc """
    same as sign_with_k in python-sdk:
    https://github.com/deepgully/pyzil/blob/master/pyzil/crypto/schnorr.py
  """
  @spec generate_signature(binary(), binary(), integer()) :: binary()
  def generate_signature(priv, payload, k) do
    priv_int = binary_to_int(priv)

    order = @g_point.order
    q_point = Point.mult(@g_point, k)
    q_point_pub = encode_public(q_point.x, q_point.y)
    pub = priv_to_compressed_pub(priv)

    r =
      q_point_pub
      |> Kernel.<>(pub)
      |> Kernel.<>(payload)
      |> Crypto.sha256()
      |> Base.encode16()
      |> String.to_integer(16)
      |> calculate_rem(order)

    s = calculate_rem(k - r * priv_int, order)

    encode_signature(r, s)
  end

  @spec encode_signature(non_neg_integer, non_neg_integer) :: <<_::512>>
  def encode_signature(r, s) do
    r_bytes = Utils.int_to_bytes(r, @encode_size)
    s_bytes = Utils.int_to_bytes(s, @encode_size)
    r_bytes <> s_bytes
  end

  @spec encode_public(non_neg_integer, non_neg_integer) :: <<_::264>>
  def encode_public(x, y) do
    tag =
      case Bitwise.band(y, 0x01) do
        # odd
        1 ->
          <<03>>

        # even
        0 ->
          <<02>>
      end

    tag <> Utils.int_to_bytes(x, @encode_size)
  end

  @spec priv_to_compressed_pub(<<_::256>>) :: <<_::264>>
  def priv_to_compressed_pub(priv) do
    {:ok, pub} = :libsecp256k1.ec_pubkey_create(priv, :compressed)
    pub
  end

  @spec binary_to_int(binary) :: integer
  def binary_to_int(binary) do
    binary
    |> Base.encode16(case: :lower)
    |> String.to_integer(16)
  end
end

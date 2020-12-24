defmodule Secp256k1.Curve do
  import Secp256k1.Utils, only: [calculate_rem: 2]
  alias Secp256k1.Point

  defstruct [:p, :a, :b]

  def contains(curve, %Point{x: x, y: y}) do
    contains(curve, x, y)
  end

  def contains(curve, x, y) do
    calculate_rem(y * y - (x * x * x + curve.a * x + curve.b), curve.p) == 0
  end
end

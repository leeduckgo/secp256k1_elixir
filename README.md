# Secp256k1

Library providing secp256k1 curve operations. Using this library you can:
- apply scalar multiplication to point(this operation used in Bitcoin private to public keys mapping)
- add two points

This code based on source code from answer:
* https://bitcoin.stackexchange.com/questions/25024/how-do-you-get-a-bitcoin-public-key-from-a-private-key

- **This library fix the bug of original library abount the calculate of rem.**

## Installation

adding `secp256k1` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
     {:secp256k1, git: "https://github.com/peatio/secp256k1", branch: "master"},
  ]
end
```


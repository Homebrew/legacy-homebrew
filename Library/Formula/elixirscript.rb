class Elixirscript < Formula
  desc "Elixir to JavaScript compiler"
  homepage "https://github.com/bryanjos/elixirscript"
  url "https://github.com/bryanjos/elixirscript/releases/download/v0.16.0/elixirscript.0.16.0.tar.gz"
  sha256 "18c44816576e7e74888bc6ce6752579d00c650bea7bde513d2f09448b0f05893"

  depends_on "erlang"

  def install
    bin.install "elixirscript/bin/elixirscript"
    prefix.install "elixirscript/Elixir.js", "elixirscript/LICENSE"
  end

  test do
    system "#{bin}/elixirscript" " -h"
  end
end

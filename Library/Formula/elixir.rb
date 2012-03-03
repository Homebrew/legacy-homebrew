require 'formula'

class Elixir < Formula
  homepage 'http://elixir-lang.org/'
  head 'https://github.com/elixir-lang/elixir.git'

  depends_on 'erlang'

  def install
    system "make"

    bin.install Dir['bin/*']
    prefix.install Dir['ebin/', 'exbin/']
  end

  def test
    system "elixir"
    system "elixirc"
    system "iex"
  end
end


require 'formula'

class ErlangInstalled < Requirement
  def message; <<-EOS.undent
    Erlang is required to install.

    You can install this with:
      brew install erlang

    Or you can use an official installer from:
      http://www.erlang.org/
    EOS
  end

  def satisfied?
    which 'erl'
  end

  def fatal?
    true
  end
end

class Elixir < Formula
  homepage 'http://elixir-lang.org/'
  url 'https://github.com/elixir-lang/elixir/tarball/v0.5.0'
  md5 'a5de19d99387c9fff44e8a56fb3a58d5'

  head 'https://github.com/elixir-lang/elixir.git'

  depends_on ErlangInstalled.new

  def install
    system "make"

    bin.install Dir['bin/*'] - Dir['bin/*.bat']
    prefix.install Dir['ebin/']
  end

  def test
    system "elixir -v"
  end
end

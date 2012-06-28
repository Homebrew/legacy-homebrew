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
  sha1 'a153ab42f06d7ba35e64e9dff9f60335e4678f7e'

  head 'https://github.com/elixir-lang/elixir.git'

  depends_on ErlangInstalled.new

  def install
    system "make"
    bin.install Dir['bin/*'] - Dir['bin/*.bat']
    prefix.install Dir['ebin/']
  end

  def test
    system "#{bin}/elixir -v"
  end
end

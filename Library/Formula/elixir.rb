require 'formula'

class ErlangInstalled < Requirement
  fatal true

  satisfy { which 'erl' }

  def message; <<-EOS.undent
    Erlang is required to install.

    You can install this with:
      brew install erlang

    Or you can use an official installer from:
      http://www.erlang.org/
    EOS
  end
end

class Elixir < Formula
  homepage 'http://elixir-lang.org/'
  url  'https://github.com/elixir-lang/elixir/archive/v0.8.1.tar.gz'
  sha1 'cb88d5c8c4543a71463fed3060f300d8933a9760'

  head 'https://github.com/elixir-lang/elixir.git'

  depends_on ErlangInstalled

  env :userpaths

  def install
    system "make"
    bin.install Dir['bin/*'] - Dir['bin/*.bat']

    Dir['lib/*/ebin'].each do |path|
      app  = File.basename(File.dirname(path))
      (lib/"#{app}").install path
    end
  end

  def test
    system "#{bin}/elixir -v"
  end
end

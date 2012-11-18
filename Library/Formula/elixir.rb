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
  url  'https://github.com/elixir-lang/elixir/tarball/v0.7.1'
  sha1 '6344b7a49196581bf45e0cb2f51a4fe3e6e07aa5'

  head 'https://github.com/elixir-lang/elixir.git', :branch => 'stable'

  depends_on ErlangInstalled.new

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

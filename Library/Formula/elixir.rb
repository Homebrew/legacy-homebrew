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
  url  'https://github.com/elixir-lang/elixir/tarball/v0.6.0'
  sha1 '618e66e037c2d930428ca75a11b4e9648caffb9a'

  head 'https://github.com/elixir-lang/elixir.git', :branch => "stable"

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

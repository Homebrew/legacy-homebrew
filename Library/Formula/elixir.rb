require 'formula'

class ErlangInstalled < Requirement
  fatal true

  satisfy { which 'erl' }

  def message; <<-EOS.undent
    Erlang R16 is required to install.

    You can install this with:
      brew tap homebrew/versions
      brew unlink erlang
      brew install erlang-r16

    Or you can use an official installer from:
      http://www.erlang.org/
    EOS
  end
end

class Elixir < Formula
  homepage 'http://elixir-lang.org/'
  url  'https://github.com/elixir-lang/elixir/archive/v0.9.1.tar.gz'
  sha1 '3896d566b6c4c75ac17fa64ee9290863b7b068f3'

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

  test do
    system "#{bin}/elixir", "-v"
  end
end

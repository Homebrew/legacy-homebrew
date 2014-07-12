require 'formula'

class ErlangInstalled < Requirement
  fatal true
  env :userpaths
  default_formula "erlang"

  satisfy {
    erl = which('erl') and begin
      `#{erl} -noshell -eval 'io:fwrite("~s~n", [erlang:system_info(otp_release)]).' -s erlang halt | grep -q '^1[789]'`
      $?.exitstatus == 0
    end
  }

  def message; <<-EOS.undent
    Erlang 17 is required to install.

    You can install this with:
      brew install erlang

    Or you can use an official installer from:
      http://www.erlang.org/
    EOS
  end
end

class Elixir < Formula
  homepage 'http://elixir-lang.org/'
  url  'https://github.com/elixir-lang/elixir/archive/v0.14.3.tar.gz'
  sha1 '52bace7b7aafed8c10e1a65887a1d375e404cee9'

  head 'https://github.com/elixir-lang/elixir.git'

  bottle do
    sha1 "3335c07c7e2bcae97ab7abada7198e17f59b9518" => :mavericks
    sha1 "458d66376eb346df44908271ca4098691ec6c61a" => :mountain_lion
    sha1 "d22e5c07b894cc6e5e5897cc12a281e1bd323bae" => :lion
  end

  depends_on ErlangInstalled

  def install
    system "make"
    bin.install Dir['bin/*'] - Dir['bin/*.{bat,ps1}']

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end

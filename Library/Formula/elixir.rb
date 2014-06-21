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
  url  'https://github.com/elixir-lang/elixir/archive/v0.14.1.tar.gz'
  sha1 '272abd87a04c592a83f43041deee986e3aadd0fe'

  head 'https://github.com/elixir-lang/elixir.git'

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

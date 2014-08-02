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
  url  'https://github.com/elixir-lang/elixir/archive/v0.15.0.tar.gz'
  sha1 'af841044c1dcb77d877cccf54c35a5b893d9f8a2'

  head 'https://github.com/elixir-lang/elixir.git'

  bottle do
    sha1 "d3206b69425e40f02fdbaeb74e64188817cef60c" => :mavericks
    sha1 "6fc717137069b8e2ee1c4c11f5958a71e1930b86" => :mountain_lion
    sha1 "d9cbaae94f3599978b719a2bdb097db97e58403a" => :lion
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

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
  url  'https://github.com/elixir-lang/elixir/archive/v1.0.3.tar.gz'
  sha1 'db40ad4f66ea9ca25257dbfa405cdb2028c56eec'

  head 'https://github.com/elixir-lang/elixir.git'

  bottle do
    sha1 "e87e4e568d79d91e72732993579608b1c5a0a10d" => :yosemite
    sha1 "2b306d49528a6031c2f2222e81abcc93952afbc6" => :mavericks
    sha1 "1be346fd8b8a829ec839bb41f73547d8d3888d76" => :mountain_lion
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

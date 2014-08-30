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
  url  'https://github.com/elixir-lang/elixir/archive/v0.15.1.tar.gz'
  sha1 '687287226c1e3412f33aa21d5c9711f3b5e7e1fb'

  devel do
    url 'https://github.com/elixir-lang/elixir/archive/v1.0.0-rc1.tar.gz'
    sha1 'cdf0bbef9b798bd204a363741fb200f7a14c2b01'
    version '1.0.0-rc1'
  end

  head 'https://github.com/elixir-lang/elixir.git'

  bottle do
    sha1 "959d12f7b8a64275f72a173e69e87607c747bf47" => :mavericks
    sha1 "a3b61300f6eb31ea210899edf155ff73312853a3" => :mountain_lion
    sha1 "70bcdbe8743fdc713600313ab9f324cc07a61712" => :lion
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

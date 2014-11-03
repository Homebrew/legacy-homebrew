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
  url  'https://github.com/elixir-lang/elixir/archive/v1.0.2.tar.gz'
  sha1 '844d32979b565de193c2e81c79ec41f3a9737a72'

  head 'https://github.com/elixir-lang/elixir.git'

  bottle do
    sha1 "4d57aa814ca74ec54e805eabcf3740c2c788fe8e" => :yosemite
    sha1 "35e8c71a39c1f83ac7c53de5ef365d142775a47d" => :mavericks
    sha1 "002e9ee58f9163a7bb5fefdaad99c905261ff6cd" => :mountain_lion
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

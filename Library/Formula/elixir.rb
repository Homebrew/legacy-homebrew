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
    sha1 "1baf4d31a9347298ad5514da1a9e57415a93854d" => :mavericks
    sha1 "412c9e90d9baf92a025983aeb9a3ef728765352e" => :mountain_lion
    sha1 "6cd04222dcfdaf63e9750d4e400879224369956e" => :lion
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

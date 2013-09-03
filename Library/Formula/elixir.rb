require 'formula'

class ErlangInstalled < Requirement
  fatal true

  satisfy {
    erl = which('erl') and begin
      `#{erl} -noshell -eval 'io:fwrite("~s~n", [erlang:system_info(otp_release)]).' -s erlang halt | grep -q '^R1[6789]'`
      $?.exitstatus == 0
    end
  }

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
  url  'https://github.com/elixir-lang/elixir/archive/v0.10.2.tar.gz'
  sha1 'fd12cfc3d7ebba9087ea1d13de6ad940c644ecf1'

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

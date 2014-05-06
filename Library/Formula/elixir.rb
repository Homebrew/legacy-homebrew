require 'formula'

class ErlangInstalled < Requirement
  fatal true
  env :userpaths

  satisfy {
    erl = which('erl') and begin
      `#{erl} -noshell -eval 'io:fwrite("~s~n", [erlang:system_info(otp_release)]).' -s erlang halt | grep -q '^1[789]'`
      $?.exitstatus == 0
    end
  }

  def message; <<-EOS.undent
    Erlang 17 is required to install.

    You can install this with:
      brew install erlang --devel

    Or you can use an official installer from:
      http://www.erlang.org/
    EOS
  end
end

class Elixir < Formula
  homepage 'http://elixir-lang.org/'
  url  'https://github.com/elixir-lang/elixir/archive/v0.13.1.tar.gz'
  sha1 'e89935019a88e76e25d6f32b1afc1568b9560892'

  head 'https://github.com/elixir-lang/elixir.git'

  depends_on ErlangInstalled

  def install
    system "make"
    bin.install Dir['bin/*'] - Dir['bin/*.bat']

    Dir['lib/*/ebin'].each do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end

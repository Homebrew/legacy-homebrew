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
  url  'https://github.com/elixir-lang/elixir/archive/v1.0.1.tar.gz'
  sha1 '7d6adade172f27efdad784ba9722e0eadbc3b746'

  head 'https://github.com/elixir-lang/elixir.git'

  bottle do
    sha1 "e26cca98fb7c128676db9476c5cf56128a9b68af" => :mavericks
    sha1 "fccdd9038d9bd46e0658f2b5d063253970b43c22" => :mountain_lion
    sha1 "d35ab17c2a501b54a861954242a1ab1f80019e94" => :lion
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

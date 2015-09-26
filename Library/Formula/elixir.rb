class Erlang17Requirement < Requirement
  fatal true
  env :userpaths
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s~n", [erlang:system_info(otp_release)]).' -s erlang halt | grep -q '^1[789]'`
    $?.exitstatus == 0
  end

  def message; <<-EOS.undent
    Erlang 17+ is required to install.

    You can install this with:
      brew install erlang

    Or you can use an official installer from:
      http://www.erlang.org/
    EOS
  end
end

class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "http://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.1.0.tar.gz"
  sha256 "6be4f083df230f901975df3a3bb32d3bd1e70a4d0a072aabc5972113b37ebb3b"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "5b046833062a838214bc5af51ac9b8a899f6bb34b040e39dd0743e1d8a465d12" => :el_capitan
    sha256 "26797b38f7adffd3c219bbd5565cfe3145c4949c9db289b930df0d9905289315" => :yosemite
    sha256 "6c31c9b53403700f78848992a36b6471b49aa12daa317bf6ff1e8811e2d8febb" => :mavericks
  end

  depends_on Erlang17Requirement

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end

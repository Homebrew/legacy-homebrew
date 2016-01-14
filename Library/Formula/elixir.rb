class Erlang18Requirement < Requirement
  fatal true
  env :userpaths
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "18"])' -s erlang halt | grep -q '^true'`
    $?.exitstatus == 0
  end

  def message; <<-EOS.undent
    Erlang 18+ is required to install.

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
  url "https://github.com/elixir-lang/elixir/archive/v1.2.1.tar.gz"
  sha256 "9def4c1ee8eede93bf7e64c1861956dc30b2edda233fef423b790c4b31aeda54"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "faacea5324fd9cedf8b8207334ff5cb600418eafa9b5f39cad95c5aa4b749bf5" => :el_capitan
    sha256 "27630ecd879acf2cf3aedca19726dfab16ec52b0ab41521f9d600ad6a571eacf" => :yosemite
    sha256 "2029ad5505b7dc6aef89a79e4df5830237953fabd013217b0ea281922fc871d9" => :mavericks
  end

  depends_on Erlang18Requirement

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

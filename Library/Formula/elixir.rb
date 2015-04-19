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
    Erlang 17 is required to install.

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
  url "https://github.com/elixir-lang/elixir/archive/v1.0.4.tar.gz"
  sha256 "79341fde3b01217aa252b8996d1b1b27cd1006cb89fe43446d5241e3dcb84bad"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "537d5760fbd780fef37a27872f1ee4d93b073a9a466a03c1f5834a804ece0275" => :yosemite
    sha256 "5aa31b974c75e1d97db4be2e88ee2a34f0518ef183471f18b0225604b362b39a" => :mavericks
    sha256 "3021ac2b3fe0aae5dfb7bb03d057ccd7df5bb9b733de35399ff7a431cae622ee" => :mountain_lion
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

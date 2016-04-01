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
  url "https://github.com/elixir-lang/elixir/archive/v1.2.4.tar.gz"
  sha256 "16759ff84d08b480b7e5499716e663b2fffd26e20cf2863de5613bc7bb05c817"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "6f591430b6088ce017564b52dcffdbe1272970efdc429b12ee124a97b349d2f6" => :el_capitan
    sha256 "99032d65dd735455ff9a517ec9a0b989b33020b22c5bcf91882cddb4f904983a" => :yosemite
    sha256 "df2c122f5937eafe8aa3b9a87c6cfdd0bc4a17b9c57ebf7c9f12082d793c60db" => :mavericks
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

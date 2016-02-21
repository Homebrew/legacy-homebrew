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
  url "https://github.com/elixir-lang/elixir/archive/v1.2.3.tar.gz"
  sha256 "886e4efea0e9bbbb4ba55ea659986fb3460c5b77045410c10144838192214827"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "2630f21033c41006cf150ceaccb81f8e3cc693a6d73d3e4949ea2cf0c0689830" => :el_capitan
    sha256 "cee92b5c7a7aff15621d05afe3f47cbd969a22704b8a9bde18088e71ec8011c6" => :yosemite
    sha256 "b8bb90251593e9ce0e8d18716b50bb0096822aec31722a1f991450e6516fcd7e" => :mavericks
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

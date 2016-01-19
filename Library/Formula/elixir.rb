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
    sha256 "81c0ceb22e1ccf8b4a64635e0cf3c8ba2b6ce163210b8abd52ec5fc6ae974b97" => :el_capitan
    sha256 "b6855bffad2d118407161484681452f3a192594ecb58344b8d060017df83c945" => :yosemite
    sha256 "32d9f8271b4519ab0036d8b1194515c918b86494454a9f3db471885be9db192f" => :mavericks
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

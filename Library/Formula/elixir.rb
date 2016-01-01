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
  url "https://github.com/elixir-lang/elixir/archive/v1.2.0.tar.gz"
  sha256 "9f68ee5213b883c91f2f521df1f773ceec5913dbf075f7781b57ac97543e7268"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "663ecb37c67e006ea31374b22cbacbb1c8625ae1db5020a5427863f9a535c622" => :el_capitan
    sha256 "33a7b3ca8a11eea513a457f29f1f590590528ec610eccea335c8c7f97a094fcc" => :yosemite
    sha256 "d3bbb6aff815ccf49c6d0082033ccdaaa9893105ee1a8fe80818d5df6648c0f7" => :mavericks
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

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
  url "https://github.com/elixir-lang/elixir/archive/v1.1.1.tar.gz"
  sha256 "3b7d6e4fdbcc82d19fa76f4e384f8a87535abcd00ef04528dc6b6706f32a106a"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "663ecb37c67e006ea31374b22cbacbb1c8625ae1db5020a5427863f9a535c622" => :el_capitan
    sha256 "33a7b3ca8a11eea513a457f29f1f590590528ec610eccea335c8c7f97a094fcc" => :yosemite
    sha256 "d3bbb6aff815ccf49c6d0082033ccdaaa9893105ee1a8fe80818d5df6648c0f7" => :mavericks
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

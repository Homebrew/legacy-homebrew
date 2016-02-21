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
    sha256 "b46ff99337bab229e4561b6590ba7ffe3e9faac0156a7b8ea1354f1942a01e50" => :el_capitan
    sha256 "7da51bcadaae886dab97d7869891cbc2eab23be56f28dbeb7a6b67f465fd172c" => :yosemite
    sha256 "5d241e80ce709ebaca7f3be066f922f835edfeb26dc4efe0f205efbddba20cc3" => :mavericks
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

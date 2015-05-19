require "formula"

class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "http://www.mruby.org"
  url "https://github.com/mruby/mruby/archive/1.1.0.tar.gz"
  sha1 "828eadbc0640d3f670a5eb24bf8d99f6bb90b5fc"

  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any
    sha1 "fc1d5229e1194203799bd2d59861d3a6919e04c9" => :yosemite
    sha1 "3e5b89430eca272eff626c5bd45eb6845ba33bcc" => :mavericks
    sha1 "4b3da67cad42fd5beba2ef64af5c58e3adc9ae7c" => :mountain_lion
  end

  depends_on "bison" => :build

  def install
    system "make"

    cd "build/host/" do
      lib.install Dir["lib/*.a"]
      prefix.install %w{bin mrbgems mrblib tools}
    end

    prefix.install "include"
  end

  test do
    system "#{bin}/mruby", "-e", "true"
  end
end

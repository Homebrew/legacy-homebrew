require "formula"

class Mruby < Formula
  homepage "http://www.mruby.org"
  url "https://github.com/mruby/mruby/archive/1.1.0.tar.gz"
  sha1 "828eadbc0640d3f670a5eb24bf8d99f6bb90b5fc"

  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any
    revision 1
    sha1 "0c35394977329935628dbc4c104f2bb435ca6501" => :mavericks
    sha1 "1205fd6c0d6ea2caff16e276e86b9b876ae354f6" => :mountain_lion
    sha1 "d7c75455a7d02d97eaf0926ed70c5520848e13b4" => :lion
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

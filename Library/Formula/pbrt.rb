require "formula"

class Pbrt < Formula
  homepage "http://pbrt.org/"
  url "http://githubredir.debian.net/github/mmp/pbrt-v2/2.0.334.tar.gz"
  sha1 "a5d1324f3ab9072bd6a88fee3cbc0c153bbb50eb"

  depends_on "openexr"

  def install
    cd "src" do
      system "make"

      cd "bin" do
        bin.install "bsdftest", "exravg", "exrdiff", "pbrt"
      end
    end
  end
end

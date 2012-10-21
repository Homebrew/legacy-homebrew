require 'formula'

class Pbrt < Formula
  homepage 'http://pbrt.org/'
  url 'https://github.com/mmp/pbrt-v2/tarball/2.0.334'
  sha1 'a5d1324f3ab9072bd6a88fee3cbc0c153bbb50eb'

  depends_on "openexr"

  def install
    cd "src" do
      system "make"
      prefix.install "bin"
    end
  end
end

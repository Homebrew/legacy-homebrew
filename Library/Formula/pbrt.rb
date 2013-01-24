require 'formula'

class Pbrt < Formula
  homepage 'http://pbrt.org/'
  url 'https://github.com/mmp/pbrt-v2/tarball/2.0.342'
  sha1 '60ca05448e69ae750b9f5cb07a1e55204d793698'

  depends_on "openexr"

  def install
    cd "src" do
      system "make"
      prefix.install "bin"
    end
  end
end

require 'formula'

class Pbrt < Formula
  homepage 'http://pbrt.org/'
  url 'https://github.com/mmp/pbrt-v2/archive/2.0.342.tar.gz'
  sha1 'c18e4cb5acdd3120573c26be702e452e77273a79'

  depends_on "openexr"
  depends_on "flex"

  def install
    system "make", "-C", "src"
    prefix.install "src/bin"
  end
end

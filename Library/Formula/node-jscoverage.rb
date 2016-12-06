require 'formula'

class NodeJscoverage < Formula
  version '0.4'
  homepage 'https://github.com/visionmedia/node-jscoverage'
  url 'https://github.com/visionmedia/node-jscoverage/tarball/master'
  md5 '5e14d36cbac3bd4387c52038150bbced'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "jscoverage -V"
  end
end

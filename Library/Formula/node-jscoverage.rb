require 'formula'

class NodeJscoverage < Formula
  homepage 'https://github.com/visionmedia/node-jscoverage'
  url 'git://github.com/visionmedia/node-jscoverage.git'
  sha1 ''


  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

  end

end

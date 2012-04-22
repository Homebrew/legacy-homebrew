require 'formula'

class Tmap < Formula
  homepage 'http://github.com/iontorrent/TMAP'
  url 'http://github.com/iontorrent/TMAP/tarball/tmap.0.3.8'
  md5 'a441bcbb681f427bada3f16a220685e4'
  version '0.3.8'

  head 'https://github.com/iontorrent/TMAP.git'

  fails_with :clang do
    build 318
  end

  def install
    system "sh autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "tmap"
  end
end

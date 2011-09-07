require 'formula'

class Libelf < Formula
  url 'http://www.mr511.de/software/libelf-0.8.13.tar.gz'
  homepage 'http://www.mr511.de/software/'
  md5 '4136d7b4c04df68b686570afa26988ac'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

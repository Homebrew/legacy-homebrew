require 'formula'

class Libelf < Formula
  homepage 'http://www.mr511.de/software/'
  url 'http://www.mr511.de/software/libelf-0.8.13.tar.gz'
  md5 '4136d7b4c04df68b686570afa26988ac'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Use separate steps; there is some kind of (transient)
    # race in the Makefile.
    system "make"
    system "make install"
  end
end

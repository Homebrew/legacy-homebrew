require 'formula'

class Libdaemon < Formula
  homepage 'http://0pointer.de/lennart/projects/libdaemon/'
  url 'http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz'
  sha1 '78a4db58cf3a7a8906c35592434e37680ca83b8f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

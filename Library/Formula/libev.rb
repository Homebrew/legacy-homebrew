require 'formula'

class Libev < Formula
  homepage 'http://software.schmorp.de/pkg/libev.html'
  url 'http://dist.schmorp.de/libev/Attic/libev-4.15.tar.gz'
  sha1 '88655b1e2c0b328c9f90a6df7e72361a97fa8dc3'

  bottle do
    cellar :any
    sha1 "fa05ffc6bb36aaccd04d233d2771217abb06613c" => :mavericks
    sha1 "6b0a5a532691c1b32856db15966077f6f533f8ae" => :mountain_lion
    sha1 "4d3015c11e6a90e0463978823d8fdba5b3a170af" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"

    # Remove compatibility header to prevent conflict with libevent
    (include/"event.h").unlink
  end
end

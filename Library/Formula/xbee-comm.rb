require 'formula'

# This fork contains OS X patches.
# Original project: https://github.com/roysjosh/xbee-comm

class XbeeComm < Formula
  homepage 'https://github.com/guyzmo/xbee-comm.git'
  url 'https://github.com/guyzmo/xbee-comm/archive/v1.5.tar.gz'
  sha1 '1eefd2818fcffb2da9e217c7df48b1ff4f72ef3a'

  head 'https://github.com/guyzmo/xbee-comm.git'

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "-a", "-c"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

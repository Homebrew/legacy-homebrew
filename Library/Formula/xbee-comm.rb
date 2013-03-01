require 'formula'

# This fork contains OS X patches.
# Original project: https://github.com/roysjosh/xbee-comm

class XbeeComm < Formula
  homepage 'https://github.com/guyzmo/xbee-comm.git'
  url 'https://github.com/guyzmo/xbee-comm/tarball/v1.5'
  sha1 '260e4ca71dabde120fd90089f0dada68d3123dcf'

  head 'https://github.com/guyzmo/xbee-comm.git'

  depends_on :automake

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

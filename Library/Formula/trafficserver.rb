require 'formula'

class Trafficserver < Formula
  homepage 'http://trafficserver.apache.org/'
  url 'http://www.eu.apache.org/dist/trafficserver/trafficserver-3.2.4.tar.bz2'
  sha1 '05b9ee455f6cdb83486132183e04443efa057c00'

  head 'http://svn.apache.org/repos/asf/trafficserver/traffic/trunk/'

  depends_on 'pcre'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "autoreconf -i" if build.head?

    # Needed for correct ./configure detections.
    ENV.enable_warnings
    # Needed for OpenSSL headers on Lion.
    ENV.append_to_cflags "-Wno-deprecated-declarations"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-user=#{ENV['USER']}",
                          "--with-group=admin",
                          "CC=clang",
                          "CXX=clang++"
    system "make install"
  end

  def test
    system "#{bin}/trafficserver", "status"
  end
end

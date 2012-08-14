require 'formula'

class Trafficserver < Formula
  homepage 'http://trafficserver.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi/trafficserver/trafficserver-3.2.0.tar.bz2'
  sha1 '0d7461f0711387b1049e50522e61281be6f5cf38'

  head 'http://svn.apache.org/repos/asf/trafficserver/traffic/trunk/'

  depends_on 'pcre'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "autoreconf -i" if ARGV.build_head?

    # Needed for correct ./configure detections.
    ENV.enable_warnings
    # Needed for OpenSSL headers on Lion.
    ENV.append_to_cflags "-Wno-deprecated-declarations"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-user=#{ENV['USER']}",
                          "--with-group=admin"
    system "make install"
  end

  def test
    system "#{bin}/trafficserver", "status"
  end
end

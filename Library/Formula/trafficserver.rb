require 'formula'

class Trafficserver < Formula
  homepage 'http://trafficserver.apache.org/'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://www.apache.org/dyn/closer.cgi/trafficserver/trafficserver-3.0.4.tar.bz2'
  md5 '90e259fb09cb7439c6908f1f5344c40f'
=======
  url 'http://www.apache.org/dyn/closer.cgi/trafficserver/trafficserver-3.2.0.tar.bz2'
  sha1 '0d7461f0711387b1049e50522e61281be6f5cf38'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'http://www.apache.org/dyn/closer.cgi/trafficserver/trafficserver-3.2.0.tar.bz2'
  sha1 '0d7461f0711387b1049e50522e61281be6f5cf38'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

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
                          "--with-group=admin"
    system "make install"
  end

  def test
    system "#{bin}/trafficserver", "status"
  end
end

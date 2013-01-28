require 'formula'

class Opensp < Formula
  homepage 'http://openjade.sourceforge.net'
  url 'http://sourceforge.net/projects/openjade/files/opensp/1.5.2/OpenSP-1.5.2.tar.gz'
  sha1 'b4e903e980f8a8b3887396a24e067bef126e97d5'

  depends_on 'gettext'

  def install
    ENV.append "LDFLAGS", "-lintl"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc-build",
                          "--enable-http"
    system "make install"
  end
end

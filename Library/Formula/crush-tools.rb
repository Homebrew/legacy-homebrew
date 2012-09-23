require 'formula'

class CrushTools < Formula
  url 'http://crush-tools.googlecode.com/files/crush-tools-2012-02.tar.gz'
  homepage 'http://crush-tools.googlecode.com/'
  sha1 'c628e3f79fa78a1437cfbe41a7ef49ecaa4d7f53'
  version '2012-02'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

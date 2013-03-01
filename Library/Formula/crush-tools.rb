require 'formula'

class CrushTools < Formula
  homepage 'http://crush-tools.googlecode.com/'
  url 'http://crush-tools.googlecode.com/files/crush-tools-2012-02.tar.gz'
  version '2012-02'
  sha1 'c628e3f79fa78a1437cfbe41a7ef49ecaa4d7f53'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

require 'formula'

class CrushTools < Formula
  url 'http://crush-tools.googlecode.com/files/crush-tools-2012-02.tar.gz'
  homepage 'http://crush-tools.googlecode.com/'
  md5 'cbf13f81c9580af3f9371a5be50ae10e'
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

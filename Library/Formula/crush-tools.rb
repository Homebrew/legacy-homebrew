require 'formula'

class CrushTools < Formula
  url 'http://crush-tools.googlecode.com/files/crush-tools-2010-03.tar.gz'
  homepage 'http://crush-tools.googlecode.com/'
  md5 '3c82e046618b1d60a05a0768f99f6b0b'
  version '2010-03'

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

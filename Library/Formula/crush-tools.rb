require 'formula'

class CrushTools < Formula
  homepage 'http://crush-tools.googlecode.com/'
  url 'https://crush-tools.googlecode.com/files/crush-tools-2013-04.tar.gz'
  version '2013-04'
  sha1 'a03a9d4719e8e049d836413598b636fd00f6a4cc'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

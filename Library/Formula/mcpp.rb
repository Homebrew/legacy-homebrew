require 'formula'

class Mcpp < Formula
  url 'http://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz'
  homepage 'http://mcpp.sourceforge.net/'
  md5 '512de48c87ab023a69250edc7a0c7b05'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-mcpplib"
    system "make install"
  end

  def patches
    "https://gist.github.com/raw/668341/e50827c8d9e8452befcab64bd8800b16d1f66d0e/mcpp-fix-stpcpy.patch"
  end
end

require 'formula'

class Librets < Formula
  url 'http://www.crt.realtors.org/projects/rets/librets/files/librets-1.6.1.tar.gz'
  homepage 'http://code.crt.realtors.org/projects/librets'
  md5 'e4f6865d044b524e4885cfb39c7cb415'

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared_dependencies",
                          "--prefix=#{prefix}",
                          "--disable-dotnet",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php",
                          "--disable-python"
    system "make install"
  end
end

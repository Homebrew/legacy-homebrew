require 'formula'

class Librets < Formula
  url 'http://www.crt.realtors.org/projects/rets/librets/files/librets-1.5.3.tar.gz'
  homepage 'http://code.crt.realtors.org/projects/librets'
  md5 'a23c8ae01f1169ea3c79438ba4e92c78'

  depends_on 'boost'
  depends_on 'swig'

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

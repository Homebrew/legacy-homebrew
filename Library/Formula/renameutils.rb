require 'formula'

class Renameutils < Formula
  homepage 'http://www.nongnu.org/renameutils/'
  url 'http://nongnu.uib.no/renameutils/renameutils-0.11.0.tar.gz'
  md5 'a3258f875d6077a06b6889de3a317dce'

  depends_on 'readline' # Use instead of system libedit

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-packager=Homebrew"
    system "make"
    ENV.deparallelize # parallel install fails
    system "make install"
  end
end

require 'formula'

class Sqsh <Formula
  depends_on 'freetds'

  url 'http://downloads.sourceforge.net/sourceforge/sqsh/sqsh-2.1.7.tar.gz'
  homepage 'http://www.sqsh.org/'
  md5 'ce929dc8e23cedccac98288d24785e2d'
  version '2.1.7'


  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]

    ENV['SYBASE']   = Freetds.new("freetds").prefix

    system "./configure", *args

    system "make install"
  end
end

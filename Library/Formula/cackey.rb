require 'formula'

class Cackey < Formula
  url 'file:///Volumes/fs/install_pkgs/cackey/cackey-0.6.5.tar.gz'
  homepage 'http://www.rkeene.org/projects/info/wiki/161'
  sha1 '89a1021e1b5c8ddb53ca396e591000ac05e51b74'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

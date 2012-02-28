require 'formula'

class Mpop < Formula
  url 'http://downloads.sourceforge.net/project/mpop/mpop/1.0.19/mpop-1.0.19.tar.bz2'
  homepage 'http://mpop.sourceforge.net/'
  md5 '40a48d486121a15075faee944a7b8fb7'

  def options
    [['--with-macosx-keyring', "Support Mac OS X Keyring"]]
  end

  def install
    args = [ "--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking"]
    args << "--with-macosx-keyring" if ARGV.include? '--with-macosx-keyring'
    system "./configure", *args
    system "make install"
  end
end

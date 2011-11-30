require 'formula'

class Msmtp < Formula
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.26/msmtp-1.4.26.tar.bz2'
  homepage 'http://msmtp.sourceforge.net'
  md5 '35734268c883aa06388742f902d95676'

  def options
    [['--with-macosx-keyring', "Support Mac OS X Keyring"]]
  end

  def install
    args = [ "--disable-dependency-tracking", "--prefix=#{prefix}" ]
    args << "--with-macosx-keyring" if ARGV.include? '--with-macosx-keyring'

    system "./configure", *args
    system "make install"
  end
end

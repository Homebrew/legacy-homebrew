require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.28/msmtp-1.4.28.tar.bz2'
  md5 '14740478dc9d1f52ec97a415e3373fc7'

  depends_on 'pkg-config' => :build

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

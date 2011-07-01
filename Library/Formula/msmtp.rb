require 'formula'

class Msmtp < Formula
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.22/msmtp-1.4.22.tar.bz2'
  homepage 'http://msmtp.sourceforge.net'
  md5 'de0a4e6f3133519b301fc114daf81f49'

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

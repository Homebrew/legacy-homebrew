require 'formula'

class Msmtp <Formula
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.19/msmtp-1.4.19.tar.bz2'
  homepage 'http://msmtp.sourceforge.net'
  md5 'f0afdc943bf7c8a3a3bf3fe1a73072c4'

  def options
    [
      ['--with-macosx-keyring', "Support Mac OS X Keyring"]
    ]
  end

  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]

    configure_args << "--with-macosx-keyring" if ARGV.include? '--with-macosx-keyring'

    system "./configure", *configure_args
    system "make install"
  end
end

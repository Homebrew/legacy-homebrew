require 'formula'

class Msmtp <Formula
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.20/msmtp-1.4.20.tar.bz2'
  homepage 'http://msmtp.sourceforge.net'
  md5 '065042eaaee40c2779cf0bcfffe72aae'

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

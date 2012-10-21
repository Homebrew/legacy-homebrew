require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.28/msmtp-1.4.28.tar.bz2'
  sha1 '3fd44b30e8f4ae071b2a5a205d6007f3465fa970'

  option 'with-macosx-keyring', "Support Mac OS X Keyring"

  depends_on 'pkg-config' => :build

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--with-macosx-keyring" if build.include? 'with-macosx-keyring'

    system "./configure", *args
    system "make install"
  end
end

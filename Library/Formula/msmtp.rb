require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.30/msmtp-1.4.30.tar.bz2'
  sha1 'fd469bae0c3394b30b771780e62bbd41c4d5d175'

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

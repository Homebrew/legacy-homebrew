require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.31/msmtp-1.4.31.tar.bz2'
  sha1 'c0edce1e1951968853f15209c8509699ff9e9ab5'

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

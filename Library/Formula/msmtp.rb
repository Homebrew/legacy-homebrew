require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.31/msmtp-1.4.31.tar.bz2'
  sha1 'c0edce1e1951968853f15209c8509699ff9e9ab5'

  depends_on 'pkg-config' => :build

  # msmtp enables OS X Keychain support by default, so no need to ask for it.

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end
end

require 'formula'

class Tinc < Formula
  homepage 'http://www.tinc-vpn.org'
  url 'http://tinc-vpn.org/packages/tinc-1.0.24.tar.gz'
  sha1 'e32f56b234922570a9a8a267b1143e2752133696'

  depends_on 'lzo'

  def install
    # Tinc does not automatically link against libresolv on Mac OS X.
    # A fix has been already merged upstream. When updating this formula
    # make sure the following changes have been applied:
    # https://github.com/gsliepen/tinc/commit/241670ec23d05800e0a04957d6293de9a39075fb
    # and remove this comment in addition to the next line.
    ENV.append 'LDFLAGS', '-lresolv'

    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end

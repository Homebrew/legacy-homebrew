require 'formula'

class Libmpq < Formula
  # Website currently has a bad SSL cert
  url 'https://libmpq.org/download/libmpq-0.4.2.tar.bz2',
      :using => CurlUnsafeDownloadStrategy

  md5 '54ec039b9654ba1662485e1bc9682850'
  homepage 'https://libmpq.org'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

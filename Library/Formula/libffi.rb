require 'formula'

class Libffi < Formula
  homepage 'http://sourceware.org/libffi/'
  url 'http://mirrors.kernel.org/sources.redhat.com/libffi/libffi-3.0.12.tar.gz'
  mirror 'ftp://sourceware.org/pub/libffi/libffi-3.0.12.tar.gz'
  sha1 '463dcb4ae9aea4c52bba12b67fbe4d91ed1e21fd'

  keg_only :provided_by_osx, "Some formulae require a newer version of libffi."

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

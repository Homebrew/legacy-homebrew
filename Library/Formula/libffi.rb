require 'formula'

class Libffi < Formula
  homepage 'http://sourceware.org/libffi/'
  url 'http://mirrors.kernel.org/sources.redhat.com/libffi/libffi-3.0.11.tar.gz'
  mirror 'ftp://sourceware.org/pub/libffi/libffi-3.0.11.tar.gz'
  sha1 'bff6a6c886f90ad5e30dee0b46676e8e0297d81d'

  keg_only :provided_by_osx, "Some formulae require a newer version of libffi."

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

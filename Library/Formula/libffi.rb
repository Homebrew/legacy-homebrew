require 'formula'

class Libffi < Formula
  url 'http://mirrors.kernel.org/sources.redhat.com/libffi/libffi-3.0.9.tar.gz'
  homepage 'http://sourceware.org/libffi/'
  sha1 '56e41f87780e09d06d279690e53d4ea2c371ea88'

  keg_only :provided_by_osx, "Guile uses this version of libffi."

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

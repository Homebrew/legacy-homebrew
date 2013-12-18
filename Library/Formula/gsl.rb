require 'formula'

class Gsl < Formula
  homepage 'http://www.gnu.org/software/gsl/'
  url 'http://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz'
  sha1 '210af9366485f149140973700d90dc93a4b6213e'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make install"
  end
end

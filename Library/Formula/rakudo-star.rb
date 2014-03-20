require 'formula'

class RakudoStar < Formula
  homepage 'http://rakudo.org/'
  url 'http://rakudo.org/downloads/star/rakudo-star-2014.01.tar.gz'
  sha256 '017e28537c88475b2d82621671a7cd8062cb29aa31ec1ecebc67efcb2e1783c8'

  conflicts_with 'parrot'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional
  depends_on 'libffi'

  def install
    libffi = Formula["libffi"]
    ENV.remove 'CPPFLAGS', "-I#{libffi.include}"
    ENV.prepend 'CPPFLAGS', "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.j1  # An intermittent race condition causes random build failures.
    system "perl", "Configure.pl", "--prefix=#{prefix}", "--backends=parrot", "--gen-parrot"
    system "make"
    system "make install"
    # move the man pages out of the top level into share.
    mv "#{prefix}/man", share
  end
end

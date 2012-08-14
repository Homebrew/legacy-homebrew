require 'formula'

class RakudoStar < Formula
  homepage 'http://rakudo.org/'
  url 'https://github.com/downloads/rakudo/star/rakudo-star-2012.07.tar.gz'
  sha256 '684cb3bb1f8fb95be10fae8d778dec41082e8f5d617aa99e919210e70b7e1b3d'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional
  depends_on 'libffi'

  def install
    libffi = Formula.factory("libffi")
    ENV.remove 'CPPFLAGS', "-I#{libffi.include}"
    ENV.prepend 'CPPFLAGS', "-I#{libffi.lib}/libffi-3.0.11/include"

    ENV.j1  # An intermittent race condition causes random build failures.
    system "perl", "Configure.pl", "--prefix=#{prefix}", "--gen-parrot"
    system "make"
    system "make install"
    # move the man pages out of the top level into share.
    mv "#{prefix}/man", share
  end

  def caveats; <<-EOS
    Raukdo Star comes with its own specific version of Parrot. Installing the
    Parrot formula along side the Rakudo Star formula will override a number
    of the binaries (eg. parrot, nqp, winxed, etc.).
    EOS
  end
end

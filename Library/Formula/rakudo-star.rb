require 'formula'

class RakudoStar < Formula
  homepage 'http://rakudo.org/'
  url 'https://github.com/downloads/rakudo/star/rakudo-star-2012.10.tar.gz'
  sha256 '69f9b6a23d647c7fb4cd5e1449e9a4ed88eb000c16e645e6f011c58ff1228c78'

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

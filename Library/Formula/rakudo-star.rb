require 'formula'

class RakudoStar < Formula
  homepage 'http://rakudo.org/'
  url 'http://rakudo.org/downloads/star/rakudo-star-2013.01.tar.gz'
  sha256 'dc1e7d0d5c8156f5399da968eaac7f8b0166b8067309e372372e6a43fd3e802b'

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
    Rakudo Star comes with its own specific version of Parrot. Installing the
    Parrot formula along side the Rakudo Star formula will override a number
    of the binaries (eg. parrot, nqp, winxed, etc.).
    EOS
  end
end

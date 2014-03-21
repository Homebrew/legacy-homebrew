require 'formula'

class Readline < Formula
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'
  url 'http://ftpmirror.gnu.org/readline/readline-6.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz'
  sha256 '56ba6071b9462f980c5a72ab0023893b65ba6debb4eeb475d7a563dc65cafd43'
  version '6.3'

  keg_only <<-EOS
OS X provides the BSD libedit library, which shadows libreadline.
In order to prevent conflicts when programs look for libreadline we are
defaulting this GNU Readline installation to keg-only.
EOS

  def install
    # Always build universal, per https://github.com/Homebrew/homebrew/issues/issue/899
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-multibyte"
    system "make install"
  end
end

require 'formula'

class Readline < Formula
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'
  url 'http://ftpmirror.gnu.org/readline/readline-6.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/readline/readline-6.2.tar.gz'
  sha256 '79a696070a058c233c72dd6ac697021cc64abd5ed51e59db867d66d196a89381'
  version '6.2.1'

  keg_only <<-EOS
OS X provides the BSD libedit library, which shadows libreadline.
In order to prevent conflicts when programs look for libreadline we are
defaulting this GNU Readline installation to keg-only.
EOS

  def patches
    {:p0 => [
        "http://ftpmirror.gnu.org/readline/readline-6.2-patches/readline62-001",
      ]}
  end

  def install
    # Always build universal, per https://github.com/mxcl/homebrew/issues/issue/899
    ENV.universal_binary
    # Fix darwin detection for Lion, see https://github.com/mxcl/homebrew/issues/4782
    inreplace 'support/shobj-conf', 'darwin[89]*|darwin10*)', 'darwin[89]*|darwin1[01]*)'
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-multibyte"
    system "make install"
  end
end

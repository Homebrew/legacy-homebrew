require 'formula'

class Readline <Formula
  url 'ftp://ftp.cwru.edu/pub/bash/readline-6.1.tar.gz'
  md5 'fc2f7e714fe792db1ce6ddc4c9fb4ef3'
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'

  keg_only <<-EOS
OS X provides the BSD Readline library. In order to prevent conflicts when
programs look for libreadline we are defaulting this GNU Readline installation
to keg-only.
EOS

  def patches
    {:p0 => [
        "ftp://ftp.gnu.org/gnu/readline/readline-6.1-patches/readline61-001",
        "ftp://ftp.gnu.org/gnu/readline/readline-6.1-patches/readline61-002",
      ]}
  end

  def install
    # Always build universal, per http://github.com/mxcl/homebrew/issues/issue/899
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-multibyte"
    system "make install"
  end
end

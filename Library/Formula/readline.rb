require 'formula'

class Readline <Formula
  url 'ftp://ftp.cwru.edu/pub/bash/readline-6.0.tar.gz'
  md5 'b7f65a48add447693be6e86f04a63019'
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'

  keg_only <<-EOS
OS X provides the BSD Readline library. In order to prevent conflicts when
programs look for libreadline we are defaulting this GNU Readline installation
to keg-only.
EOS

  def patches
    patches = (1..5).collect { |n| "ftp://ftp.gnu.org/gnu/readline/readline-6.0-patches/readline60-%03d"%n }
    { :p0 => patches }
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

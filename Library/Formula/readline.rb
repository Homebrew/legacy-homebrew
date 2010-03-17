require 'formula'

class Readline <Formula
  url 'ftp://ftp.cwru.edu/pub/bash/readline-6.0.tar.gz'
  md5 'b7f65a48add447693be6e86f04a63019'
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'

  def keg_only? ; <<-EOS
OS X provides the BSD Readline library. In order to prevent conflicts when
programs look for libreadline we are defaulting this GNU Readline installation
to keg-only.
    EOS
  end

  def options
    [
      ["--universal", "Build both i386 and x86_64."]
    ]
  end

  def patches
    patches = (1..4).collect { |n| "ftp://ftp.gnu.org/gnu/readline/readline-6.0-patches/readline60-%03d"%n }
    { :p0 => patches }
  end

  def install
    ENV.universal_binary if ARGV.include? "--universal"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-multibyte"
    system "make install"
  end
end

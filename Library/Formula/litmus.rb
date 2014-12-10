require 'formula'

class Litmus < Formula
  homepage 'http://www.webdav.org/neon/litmus/'
  url 'http://www.webdav.org/neon/litmus/litmus-0.13.tar.gz'
  sha1 '42ad603035d15798facb3be79b1c51376820cb19'

  def install
    # Note that initially this formula also had the --disable-debug option
    # passed to ./configure.
    #
    # This disabled a critical feature. Litmus is a debugging tool, and this
    # caused all logs to be empty by default.
    #
    # See: https://github.com/Homebrew/homebrew/pull/29608
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

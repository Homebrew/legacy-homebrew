require 'brewkit'

class Gnupg <Formula
  @url='ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.9.tar.bz2'
  @homepage='http://www.gnupg.org/'
  @sha1='826f4bef1effce61c3799c8f7d3cc8313b340b55'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"

    system "make"
    system "make check"

    # amazingly even the GNU folks can bugger up their Makefiles, so we need
    # to create these directories because the install target has the
    # dependency order wrong
    bin.mkpath
    (libexec+'gnupg').mkpath
    system "make install"
  end
end

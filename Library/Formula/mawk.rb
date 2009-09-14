require 'brewkit'

class Mawk <Formula
  @url='http://invisible-island.net/datafiles/release/mawk.tar.gz'
  @homepage='http://www.gnu.org/software/gnugo/gnugo.html'
  @md5='5d42d8c3fb9f54f3e35fe56d7b62887e'
  @version='1.3.3'

  def patches
    {
      :p1 => ["http://bitbucket.org/0xffea/patches/raw/6402e50a132f/homebrew/mawk-001-shell.diff"]
    }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-readline=/usr/lib"
    system "make install"
  end
end

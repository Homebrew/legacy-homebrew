require 'formula'

class GnuChess < Formula
  homepage 'http://www.gnu.org/software/chess/'
  url 'http://ftpmirror.gnu.org/chess/gnuchess-6.0.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/chess/gnuchess-6.0.1.tar.gz'
  md5 '041888218f73886f146fa7fbf92190de'

  def install
    # Opening book for gnuchess.  This can be put in the doc directory and the
    # user can optionally add the opening book.  The README has details on
    # adding the opening book.
    book_url = "http://ftpmirror.gnu.org/chess/book_1.02.pgn.gz"
    ohai "Downloading #{book_url}"
    curl book_url, "-O"

    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # Prevents a "file already exists" warning
    system "make install"
    doc.install Dir['doc/*', 'TODO', 'book_1.02.pgn.gz', 'book']
  end

  def caveats; <<-EOS.undent
    The README file contains a manual for use:
      #{doc}/README

    This formula also downloads the additional opening book.  The opening
    book is a gzipped PGN file that can be added using gnuchess commands.
    The book_*.pgn.gz file is located in the same directory as the README.
    See the README for using the `book add' command.
    EOS
  end
end

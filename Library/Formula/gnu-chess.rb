require 'formula'

class GnuChess <Formula
  url 'http://ftp.gnu.org/pub/gnu/chess/gnuchess-5.07.tar.gz'
  homepage 'http://www.gnu.org/software/chess/'
  md5 '259da00aa559e5624c65279484fccaf7'

  def patches
    # v4 of the gcc compiler uncovered an error in the code that should be corrected in
    # the 5.08 version of gnuchess.
    #
    # The error:
    # input.c:95: error: static declaration of ‘input_thread’ follows non-static declaration
    #
    # The patch removes 'static' from the declaration in input.c.  See msg at
    # http://www.mail-archive.com/bug-gnu-chess@gnu.org/msg00218.html
    DATA
  end

  def install
    # Opening book for gnuchess.  This can be put in the doc directory and the
    # user can optionally add the opening book.  The README has details on
    # adding the opening book.
    book_url = "http://ftp.gnu.org/pub/gnu/chess/book_1.01.pgn.gz"
    ohai "Downloading #{book_url}"
    curl book_url, "-O"

    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # Prevents a "file already exists" warning
    system "make install"
    doc.install Dir['doc/*']
    doc.install ['TODO', 'book_1.01.pgn.gz', 'book']
  end

  def caveats
    <<-EOS.undent
      The README file contains a manual for use:
      
        #{doc}/README
      
      This formula also downloads the additional opening book.  The opening
      book is a gzipped PGN file that can be added using gnuchess commands.
      The book_*.pgn.gz file is located in the same directory as the README.
      See the README for using the `book add' command.
    EOS
  end
end
__END__
diff --git a/src/input.c b/src/input.c
index 1fb9be3..5f0ff79 100644
--- a/src/input.c
+++ b/src/input.c
@@ -92,7 +92,7 @@ void getline_standard(char *p)
   fgets(inputstr, MAXSTR, stdin);
 }

-static pthread_t input_thread;
+pthread_t input_thread;

 /* Mutex and condition variable for thread communication */

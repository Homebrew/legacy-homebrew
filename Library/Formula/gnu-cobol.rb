require "formula"

class GnuCobol < Formula
  homepage "http://www.opencobol.org/"
  url 'https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/1.1/gnu-cobol-1.1.tar.gz'
  sha1 "86e928c43cb3372f1f4564f3fd5e1dde668e8c1f"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db4"
  depends_on "gmp"

  def install
    gmp = Formula["gmp"]
    bdb = Formula["berkeley-db4"]

    # both environment variables are needed to be set
    # the cobol compiler takes these variables for calling cc during its run
    # if the paths to gmp and bdb are not provided, the run of cobc fails
    ENV.append "CPPFLAGS", "-I#{gmp.opt_include} -I#{bdb.opt_include}"
    ENV.append "LDFLAGS", "-L#{gmp.opt_lib} -L#{bdb.opt_lib}"

    args = ["--prefix=#{prefix}", "--infodir=#{info}"]
    args << "--with-libiconv-prefix=/usr"
    args << "--with-libintl-prefix=/usr"

    system "aclocal"

    # fix referencing of libintl and libiconv for ld
    # bug report can be found here: https://sourceforge.net/p/open-cobol/bugs/93/
    inreplace "configure", "-R$found_dir", "-L$found_dir"

    system "./configure", *args

    system "make", "install"
  end

  test do
    (testpath/'hello.cob').write('       IDENTIFICATION DIVISION.
       PROGRAM-ID. hello.
       PROCEDURE DIVISION.
       DISPLAY "Hello World!".
       STOP RUN.')
    system "#{bin}/cobc", "-x", testpath/'hello.cob'
    system testpath/'hello'
  end
end

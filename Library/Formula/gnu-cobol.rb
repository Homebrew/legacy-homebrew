require "formula"

class GnuCobol < Formula
  homepage "http://www.opencobol.org/"
  url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/1.1/gnu-cobol-1.1.tar.gz"
  sha1 "86e928c43cb3372f1f4564f3fd5e1dde668e8c1f"

  devel do
    version "2.0_nightly_r411"
    url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/2.0/gnu-cobol-2.0_nightly_r411.tar.gz"
    sha1 "009215c090b9a90fbf02bbc913095ce2a9b31910"
  end

  bottle do
    revision 1
    sha1 "0faef373e0364a8c92e32b828904e0fc10198aab" => :mavericks
    sha1 "cf08ce9301cfb80a882b37587ef0b9cb5c96f70b" => :mountain_lion
    sha1 "fc50ad8ec550f6d347044778b795688e4f18ad24" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db4"
  depends_on "gmp"

  if build.stable?
    fails_with :clang do
      cause <<-EOS.undent
        Building with Clang configures GNU-COBOL to use Clang as its compiler,
        which causes subsequent GNU-COBOL-based builds to fail.
      EOS
    end
  end

  def install
    # both environment variables are needed to be set
    # the cobol compiler takes these variables for calling cc during its run
    # if the paths to gmp and bdb are not provided, the run of cobc fails
    gmp = Formula["gmp"]
    bdb = Formula["berkeley-db4"]
    ENV.append "CPPFLAGS", "-I#{gmp.opt_include} -I#{bdb.opt_include}"
    ENV.append "LDFLAGS", "-L#{gmp.opt_lib} -L#{bdb.opt_lib}"

    args = ["--prefix=#{prefix}", "--infodir=#{info}"]
    args << "--with-libiconv-prefix=/usr"
    args << "--with-libintl-prefix=/usr"

    if build.stable?
      system "aclocal"

      # fix referencing of libintl and libiconv for ld
      # bug report can be found here: https://sourceforge.net/p/open-cobol/bugs/93/
      inreplace "configure", "-R$found_dir", "-L$found_dir"

      args << "--with-cc=#{ENV.cc}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"hello.cob").write <<-EOS
       IDENTIFICATION DIVISION.
       PROGRAM-ID. hello.
       PROCEDURE DIVISION.
       DISPLAY "Hello World!".
       STOP RUN.
    EOS
    system "#{bin}/cobc", "-x", testpath/"hello.cob"
    system testpath/"hello"
  end
end

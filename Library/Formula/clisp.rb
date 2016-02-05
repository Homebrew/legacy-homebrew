class Clisp < Formula
  desc "GNU CLISP, a Common Lisp implementation"
  homepage "http://www.clisp.org/"
  url "http://ftpmirror.gnu.org/clisp/release/2.49/clisp-2.49.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/clisp/release/2.49/clisp-2.49.tar.bz2"
  sha256 "8132ff353afaa70e6b19367a25ae3d5a43627279c25647c220641fed00f8e890"

  bottle do
    sha256 "cbd72b99874b8a53da52938f41122e741cccb1e300c2bbf3175f6cefbe48a100" => :yosemite
    sha256 "00d23db5b9accb0072a1b14d6adf1ddfd11112c5c36faa7e68c03f2727aa3be9" => :mavericks
    sha256 "4acc75971d4dd0a316586b38cfa53162887104a9e9a33a0ca26134a3696307e0" => :mountain_lion
  end

  depends_on "libsigsegv"
  depends_on "readline"

  fails_with :llvm do
    build 2334
    cause "Configure fails on XCode 4/Snow Leopard."
  end

  patch :DATA

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/e2cc7c1/clisp/patch-src_lispbibl_d.diff"
    sha256 "fd4e8a0327e04c224fb14ad6094741034d14cb45da5b56a2f3e7c930f84fd9a0"
  end

  def install
    ENV.deparallelize # This build isn't parallel safe.
    ENV.O0 # Any optimization breaks the build

    # Clisp requires to select word size explicitly this way,
    # set it in CFLAGS won't work.
    ENV["CC"] = "#{ENV.cc} -m#{MacOS.prefer_64_bit? ? 64 : 32}"

    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=yes"

    cd "src" do
      # Multiple -O options will be in the generated Makefile,
      # make Homebrew's the last such option so it's effective.
      inreplace "Makefile" do |s|
        s.change_make_var! "CFLAGS", "#{s.get_make_var("CFLAGS")} #{ENV["CFLAGS"]}"
      end

      # The ulimit must be set, otherwise `make` will fail and tell you to do so
      system "ulimit -s 16384 && make"

      if MacOS.version >= :lion
        opoo <<-EOS.undent
           `make check` fails so we are skipping it.
           However, there will likely be other issues present.
           Please take them upstream to the clisp project itself.
        EOS
      else
        # Considering the complexity of this package, a self-check is highly recommended.
        system "make", "check"
      end

      system "make", "install"
    end
  end

  test do
    system "#{bin}/clisp", "--version"
  end
end

__END__
diff --git a/src/stream.d b/src/stream.d
index 5345ed6..cf14e29 100644
--- a/src/stream.d
+++ b/src/stream.d
@@ -3994,7 +3994,7 @@ global object iconv_range (object encoding, uintL start, uintL end, uintL maxint
 nonreturning_function(extern, error_unencodable, (object encoding, chart ch));
 
 /* Avoid annoying warning caused by a wrongly standardized iconv() prototype. */
-#ifdef GNU_LIBICONV
+#if defined(GNU_LIBICONV) && !defined(__APPLE_CC__)
   #undef iconv
   #define iconv(cd,inbuf,inbytesleft,outbuf,outbytesleft) \
     libiconv(cd,(ICONV_CONST char **)(inbuf),inbytesleft,outbuf,outbytesleft)

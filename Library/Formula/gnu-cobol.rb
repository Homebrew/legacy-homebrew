require "formula"

class GnuCobol < Formula
  homepage "http://www.opencobol.org/"
  url 'https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/1.1/gnu-cobol-1.1.tar.gz'
  sha1 "86e928c43cb3372f1f4564f3fd5e1dde668e8c1f"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db4"
  depends_on "gmp"
  depends_on "gettext" => :optional
  depends_on "libiconv" => :optional

  def install
    ENV.append "CPPFLAGS", "-I#{HOMEBREW_PREFIX}/opt/gmp/include -I#{HOMEBREW_PREFIX}/opt/berkeley-db4/include"
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/opt/gmp/lib -L#{HOMEBREW_PREFIX}/opt/berkeley-db4/lib"

    args = ["--prefix=#{prefix}", "--infodir=#{prefix}/share/info"]
    args << "--with-libiconv-prefix=#{HOMEBREW_PREFIX}/opt/libiconv" if build.with? "libiconv"
    args << "--with-libintl-prefix=#{HOMEBREW_PREFIX}/opt/gettext" if build.with? "gettext"

    system "aclocal"

    # fix referencing of libintl for ld
    inreplace "configure", "-R$found_dir", "-L$found_dir"

    system "./configure", *args

    system "make", "install"
  end

  test do
    system "#{bin}/cob-config", "--version"
  end
end

require "formula"

class Dos2unix < Formula
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.0.6.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/6.0.6/dos2unix-6.0.6.tar.gz"
  sha1 "95db60b4483fc66d93f96fb810e3eccd58e22dbb"

  depends_on "gettext"

  devel do
    url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.1-beta5.tar.gz"
    sha1 "39c2a344fc5ce7e3192c05cdd82835ca4110e9fa"
  end

  def install
    gettext = Formula["gettext"]
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CPP=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "CFLAGS_OS=-I#{gettext.include}",
                   "LDFLAGS_EXTRA=-L#{gettext.lib} -lintl",
                   "install"
  end

  test do
    # write a file with lf
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end

require "formula"

class Dos2unix < Formula
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.0.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.0.0/dos2unix-7.0.tar.gz"
  sha1 "a0c5d20b95f87556ddad226217cc9998c5a0bb70"

  bottle do
    sha1 "a616d74ea7f23a01f0cdc47a025eb3a258518ca1" => :mavericks
    sha1 "2f977ec55907fdc5f707a24ad550d5f92853f482" => :mountain_lion
    sha1 "a71748546f87f402ec70eb252c4c72a6812c4163" => :lion
  end

  depends_on "gettext"

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

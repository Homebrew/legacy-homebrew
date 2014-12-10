require "formula"

class Dos2unix < Formula
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.1/dos2unix-7.1.tar.gz"
  sha1 "f8247eda06aab93fbbe84b78fe6d14bd319f0fcd"

  bottle do
    sha1 "1c82d8e4870beac2033ed0675cf4534c68425ec7" => :yosemite
    sha1 "ae53df227748c6d0b0e7f5d8aab49b29a56b6b8b" => :mavericks
    sha1 "48039984312f59e77b5df9a3e6601acb96743a1d" => :mountain_lion
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

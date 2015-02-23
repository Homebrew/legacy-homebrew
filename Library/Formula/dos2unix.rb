require "formula"

class Dos2unix < Formula
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.2/dos2unix-7.2.tar.gz"
  sha1 "a8f3d048859acb5483c8e15a1dfd0a01a2bcabe0"

  bottle do
    sha1 "cf86c34ea9d8f2fefae59967deed0fd7364a04ae" => :yosemite
    sha1 "a11ddbb12f414bd017aa53957f255fad58677878" => :mavericks
    sha1 "3a7e49a6b78bffda1ead127b185e9a24ee14655e" => :mountain_lion
  end

  depends_on "gettext"

  def install
    gettext = Formula["gettext"]
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CPP=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "CFLAGS_OS=-I#{gettext.include}",
                   "LDFLAGS_EXTRA=-L#{gettext.lib} #{"-lintl" if OS.mac?}",
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

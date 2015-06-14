require "formula"

class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.2.1.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.2.1/dos2unix-7.2.1.tar.gz"
  sha256 "53928aa9abbf49939fc0b84f408a4820d11e77e41d832612c37168f98c6945f3"

  bottle do
    sha256 "616b1396b9e1860b236adce47dbaa61a216eb5eb13dd9b32d29f351b4d8f0f81" => :yosemite
    sha256 "612be4a1be16c9e52736f8a05d9fbf43692eb7132bf3cd1a6cd5c7f37ce1ce85" => :mavericks
    sha256 "2bc7821ed30d3b4ba34885bcf4f0435e8838bb5f6aa16f145c0f5443fbab3062" => :mountain_lion
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

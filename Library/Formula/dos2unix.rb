class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.3.3/dos2unix-7.3.3.tar.gz"
  sha256 "5c910aea2eae96663c67e87627998c4fe3cded403be5819b4c190e56c82ff0fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "d039be7c3fbfed7196887792433d3838e8fe7df2c49a2af7112a0116e419146a" => :el_capitan
    sha256 "7c2523cbddc1427e7070820215ce8ffd0eaddeb855202334a000d1604b0fb996" => :yosemite
    sha256 "9863db2f793de9af14c1cf6d19aa0fe4a491a82cfcbbee1a2bac2b79a80413af" => :mavericks
  end

  option "with-gettext", "Build with Native Language Support"

  depends_on "gettext" => :optional

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      install
    ]

    if build.without? "gettext"
      args << "ENABLE_NLS="
    else
      gettext = Formula["gettext"]
      args << "CFLAGS_OS=-I#{gettext.include}"
      args << "LDFLAGS_EXTRA=-L#{gettext.lib} -lintl"
    end

    system "make", *args
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

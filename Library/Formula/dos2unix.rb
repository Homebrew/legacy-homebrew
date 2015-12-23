class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.3.2/dos2unix-7.3.2.tar.gz"
  sha256 "c7e8ee0bb3e001cc25a4a908d9a81ac52d124133d6a524a59f995bc90d438689"

  bottle do
    cellar :any_skip_relocation
    sha256 "886a78adf2a767701e465fdf5c1023091df426236a72e05c91e259d0c9fe4f94" => :el_capitan
    sha256 "f40a28d1464de115f92e86e24780021a06c068c71dbaa91dab2882c3666563ad" => :yosemite
    sha256 "cc94e34364107792aa714a8e763389badef404097866c642d2446629c52aa21e" => :mavericks
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

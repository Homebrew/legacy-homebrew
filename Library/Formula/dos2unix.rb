class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.3.2/dos2unix-7.3.2.tar.gz"
  sha256 "c7e8ee0bb3e001cc25a4a908d9a81ac52d124133d6a524a59f995bc90d438689"

  bottle do
    cellar :any_skip_relocation
    sha256 "7168cf225befc0bb1bd4a435e3311444407ce1f37be4d42059d694e7cf9230ab" => :el_capitan
    sha256 "e278bc37bfc17d64b269fab313f8d9ed2a2af3361b8204c7ca2bd2d55404d15f" => :yosemite
    sha256 "61ef99b643f822bd8644124d4225ce46e39ee9912787737b1d1efe42170d11ab" => :mavericks
  end

  devel do
    url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.3-beta2.tar.gz"
    sha256 "abd12dff242b904eee1ce8141c0cf5664e6164248bf91f58f551ab7455d4d5e2"
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

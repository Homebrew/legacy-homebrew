class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.3/dos2unix-7.3.tar.gz"
  sha256 "8175f7552a72edaaa8918fdee68ce2cbc982dc25452f33d4dc611d769f4944d1"

  bottle do
    cellar :any
    sha256 "c70b03f60b52144cbcfadcf3b9fc35ca4140a8927364e2f88daac20ad614f4da" => :yosemite
    sha256 "eddb0cb3f7b3ab3ab52d7d55e925fc649262adc8590a96df3c84d723cea23eef" => :mavericks
    sha256 "fded9be40db63372d20db2ff4f1d8b724fb326a7c7ee4d9df67c8d250f2c0cd5" => :mountain_lion
  end

  devel do
    url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3-beta3.tar.gz"
    sha256 "4b34d0aa81891795566982af901a84efd54344e1e1bcba138329eb5afe0fdc68"
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

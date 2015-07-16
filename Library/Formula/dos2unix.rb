class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.2.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.2.3/dos2unix-7.2.3.tar.gz"
  sha256 "8039ea97a9fc3b0bffed0218099aeb078ebb550127fa6c10e2647aad52669c83"

  bottle do
    cellar :any
    revision 1
    sha256 "04f84521cde18edf147398e2a9f0052888e66afb438fc7bca453e07072d0655d" => :yosemite
    sha256 "6362fd9b98df16e16e71fb32c68b833cf5409d42c23d795b89bd1b2f1718e517" => :mavericks
    sha256 "7a03ca7f532b3d45934affe29e29ff46bf614007da48928fa94ba9eed3ada583" => :mountain_lion
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

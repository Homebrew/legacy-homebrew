class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "http://waterlan.home.xs4all.nl/dos2unix.html"
  url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/dos2unix/dos2unix/7.3/dos2unix-7.3.tar.gz"
  sha256 "8175f7552a72edaaa8918fdee68ce2cbc982dc25452f33d4dc611d769f4944d1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e58a7e32a7b4df3b4eca6602c30d68ed453d320f0c7421db74f11fc9570a1f5d" => :el_capitan
    sha256 "e96ff5e45c973dab929268c07b40fc8d88b40cfa78cb814c0474c2640d4f9c98" => :yosemite
    sha256 "43fea7b719cf2e08d7d833bcd6ec159747db1a4c844286d6a8198a1ac2ea30f1" => :mavericks
    sha256 "d7b8e6c2296510ccf757cf17c44238bc5fac7b5b55505caf082d547069906f0b" => :mountain_lion
  end

  devel do
    url "http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.3.1-beta5.tar.gz"
    sha256 "fb0933de4ba214a15d8e258a1031ac3c7f02f801b5b5c3a393d04a4bce21b351"
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

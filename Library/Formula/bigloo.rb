class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.1a-2.tar.gz"
  version "4.1a-2"
  sha256 "5db2e7cdb7aa4bb380f35a2a476d282842df72febdb934545b475e0932fad927"
  revision 1

  bottle do
    sha256 "042dcc5db6526cfa2854bbb82e326c123cc855e6ecf8bee0558016d0ea03522e" => :el_capitan
    sha256 "e6eccc6930e392a68ad4119faf02ebcd1441224e2c1e31bd7f854be284097c89" => :yosemite
    sha256 "859d76572635457a644aa0224e9dba1014046b52a0d6ad05cba2d35c904410c1" => :mavericks
  end

  option "with-jvm", "Enable JVM support"

  depends_on "openssl"
  depends_on "gmp" => :recommended

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      objs/obj_u/Ieee/dtoa.c:262:79504: fatal error: parser
      recursion limit reached, program too complex
    EOS
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man1}",
            "--infodir=#{info}",
            "--customgc=yes",
            "--os-macosx",
            "--native=yes",
            "--disable-alsa",
            "--disable-mpg123",
            "--disable-flac",
           ]

    args << "--jvm=yes" if build.with? "jvm"
    args << "--no-gmp" if build.without? "gmp"

    # SRFI 27 is 32-bit only
    args << "--disable-srfi27" if MacOS.prefer_64_bit?

    system "./configure", *args

    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    assert_match "Bigloo (4", shell_output("bigloo --help")
  end
end

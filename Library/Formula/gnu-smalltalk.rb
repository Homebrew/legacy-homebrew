class GnuSmalltalk < Formula
  desc "GNU Smalltalk interpreter and image"
  homepage "http://smalltalk.gnu.org/"
  url "http://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  revision 1

  head "https://github.com/bonzini/smalltalk.git"

  bottle do
    sha256 "ca6ce25f919156ff2adc37edcf6de586ff5ec627c353437f3fcc6def42c66352" => :yosemite
    sha256 "9fa7f4649c47babb31db56fc7a28ceac6168c4eee8f33609b690cd36c02255d0" => :mavericks
    sha256 "a17bac059b377e047360ea70d7c155116b1f6734765b22391f4ffaa1db7b00af" => :mountain_lion
  end

  devel do
    url "ftp://alpha.gnu.org/gnu/smalltalk/smalltalk-3.2.90.tar.gz"
    mirror "https://www.mirrorservice.org/sites/alpha.gnu.org/gnu/smalltalk/smalltalk-3.2.90.tar.gz"
    sha256 "aa6cab17841f999c9217cdccd185a74e42fc6a7fc17139120dad8815bdff137c"
  end

  option "with-tests", "Verify the build with make check (this may hang)"
  option "with-tcltk", "Build the Tcl/Tk module that requires X11"

  deprecated_option "tests" => "with-tests"
  deprecated_option "tcltk" => "with-tcltk"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :run
  depends_on "pkg-config" => :build
  depends_on "gawk" => :build
  depends_on "readline"
  depends_on "gnutls"
  depends_on "libffi" => :recommended
  depends_on "libsigsegv" => :recommended
  depends_on "glew" => :optional
  depends_on :x11 if build.with? "tcltk"

  fails_with :llvm do
    build 2334
    cause "Codegen problems with LLVM"
  end

  def install
    ENV.m32 unless MacOS.prefer_64_bit?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gtk
      --with-readline=#{Formula["readline"].opt_lib}
    ]

    if build.without? "tcltk"
      args << "--without-tcl" << "--without-tk" << "--without-x"
    end

    # disable generational gc in 32-bit and if libsigsegv is absent
    if !MacOS.prefer_64_bit? || build.without?("libsigsegv")
      args << "--disable-generational-gc"
    end

    system "autoreconf", "-ivf"
    system "./configure", *args
    system "make"
    system "make", "-j1", "check" if build.with? "tests"
    system "make", "install"
  end

  test do
    path = testpath/"test.gst"
    path.write "0 to: 9 do: [ :n | n display ]\n"

    assert_match /0123456789/, shell_output("#{bin}/gst #{path}")
  end
end

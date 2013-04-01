require 'formula'

class GnuSmalltalk < Formula
  homepage 'http://smalltalk.gnu.org/'
  url 'http://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.4.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.4.tar.xz'
  sha1 '75b7077a02abb2ec01c5975e22d6138b541db38e'

  head 'https://github.com/bonzini/smalltalk.git'

  option 'tests', 'Verify the build with make check (this may hang)'
  option 'tcltk', 'Build the Tcl/Tk module that requires X11'

  # Need newer versions on Snow Leopard
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  depends_on 'pkg-config' => :build
  depends_on 'xz'         => :build
  depends_on 'gawk'       => :build
  depends_on 'readline'   => :build
  depends_on 'libffi'     => :recommended
  depends_on 'libsigsegv' => :recommended
  depends_on 'glew'       => :optional
  depends_on :x11 if build.include? 'tcltk'

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
      --with-readline=#{Formula.factory('readline').lib}
    ]
    unless build.include? 'tcltk'
      args << '--without-tcl' << '--without-tk' << '--without-x'
    end

    # disable generational gc in 32-bit and if libsigsegv is absent
    if !MacOS.prefer_64_bit? or build.without? "libsigsegv"
      args << "--disable-generational-gc"
    end

    # Compatibility with Automake 1.13+, fixed upstream
    inreplace %w{configure.ac sigsegv/configure.ac},
      'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    inreplace 'snprintfv/configure.ac', 'AM_PROG_CC_STD', ''

    system 'autoreconf', '-ivf'
    system "./configure", *args
    system "make"
    system 'make', '-j1', 'check' if build.include? 'tests'
    system "make install"
  end
end

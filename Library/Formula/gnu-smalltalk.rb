require 'formula'

class GnuSmalltalk < Formula
  homepage 'http://smalltalk.gnu.org/'
  url 'http://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz'
  sha1 '0eb5895b9b5bebe4f75308efbe34f8721fc2fd6b'
  revision 1

  devel do
    url 'ftp://alpha.gnu.org/gnu/smalltalk/smalltalk-3.2.90.tar.gz'
    sha1 'dd8bba5702591f0d5e2676878e1b3ee48f0ff37f'
  end

  head 'https://github.com/bonzini/smalltalk.git'

  option 'tests', 'Verify the build with make check (this may hang)'
  option 'tcltk', 'Build the Tcl/Tk module that requires X11'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  depends_on 'pkg-config' => :build
  depends_on 'gawk'       => :build
  depends_on 'readline'   => :build
  depends_on 'libffi'     => :recommended
  depends_on 'libsigsegv' => :recommended
  depends_on 'glew'       => :optional
  depends_on :x11 if build.include? 'tcltk'
  depends_on 'gnutls'

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
      --with-readline=#{Formula['readline'].lib}
    ]
    unless build.include? 'tcltk'
      args << '--without-tcl' << '--without-tk' << '--without-x'
    end

    # disable generational gc in 32-bit and if libsigsegv is absent
    if !MacOS.prefer_64_bit? or build.without? "libsigsegv"
      args << "--disable-generational-gc"
    end

    system 'autoreconf', '-ivf'
    system "./configure", *args
    system "make"
    system 'make', '-j1', 'check' if build.include? 'tests'
    system "make install"
  end

  test do
    path = testpath/"test.gst"
    path.write "0 to: 9 do: [ :n | n display ]\n"

    output = `#{bin}/gst #{path}`.strip
    assert_equal "0123456789", output
    assert_equal 0, $?.exitstatus
  end
end

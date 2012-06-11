require 'formula'

class Znc < Formula
  url 'http://znc.in/releases/archive/znc-0.206.tar.gz'
  md5 'b7d3f21da81abaeb553066b0e10beb53'
  homepage 'http://wiki.znc.in/ZNC'
  head 'https://github.com/znc/znc.git'

  depends_on 'pkg-config' => :build
  depends_on 'c-ares' => :optional
  depends_on 'python3' => :optional
  depends_on 'swig' => :optional

  skip_clean 'bin/znc'
  skip_clean 'bin/znc-config'
  skip_clean 'bin/znc-buildmod'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def options
    [['--enable-debug', "Compile ZNC with --enable-debug"]]
  end

  def install
    args = ["--prefix=#{prefix}", "--enable-extra"]
    args << "--enable-debug" if ARGV.include? '--enable-debug'
    args << "--enable-tcl"

    if Formula.factory('swig').installed?
      args << "--enable-python" if Formula.factory('python3').installed?
      #args << "--enable-perl" if ARGV.build_head?
    end

    system "./autogen.sh" if ARGV.build_head?
    system "./configure", *args
    system "make install"
  end
end

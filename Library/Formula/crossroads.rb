require 'formula'

class Crossroads < Formula
  homepage 'http://www.crossroads.io/'
  url 'http://download.crossroads.io/libxs-1.2.0.tar.gz'
  md5 'aac1264bb0d03704bd2126419b981fd5'
  head 'https://github.com/crossroads-io/libxs.git'

  fails_with :llvm do
    build 2326
    cause "Compiling with LLVM gives a segfault while linking."
  end

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def options
    [['--with-pgm', 'Build with PGM extension']]
  end

  def install
    system "./autogen.sh" if ARGV.build_head?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--with-pgm" if ARGV.include? '--with-pgm'
    system "./configure", *args

    system "make"
    system "make install"
  end
end

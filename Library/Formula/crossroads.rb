require 'formula'

def pgm_flags
  return ARGV.include?('--with-pgm') ? "--with-pgm" : ""
end

class Crossroads < Formula
  url 'http://download.crossroads.io/libxs-1.0.0.tar.gz'
  head 'git://github.com/crossroads-io/libxs.git'
  homepage 'http://http://www.crossroads.io/'
  md5 '12aaeaa76bd8a378246f2602c4d8d912'

  fails_with_llvm "Compiling with LLVM gives a segfault while linking.",
                  :build => 2326 if MacOS.snow_leopard?

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def options
    [
      ['--with-pgm', 'Build with PGM extension']
    ]
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

require 'formula'

def pgm_flags
  return ARGV.include?('--with-pgm') ? "--with-pgm" : ""
end

class Zeromq < Formula
  url 'http://download.zeromq.org/zeromq-2.1.10.tar.gz'
  head 'https://github.com/zeromq/libzmq.git'
  homepage 'http://www.zeromq.org/'
  md5 'f034096095fa76041166a8861e9d71b7'

  fails_with_llvm "Compiling with LLVM gives a segfault while linking.",
                  :build => 2326 if MacOS.snow_leopard?

  def options
    [
      ['--with-pgm', 'Build with PGM extension'],
      ['--universal', 'Build as a Universal Intel binary.']
    ]
  end

  def build_fat
    # make 32-bit
    system "CFLAGS=\"$CFLAGS -arch i386\" CXXFLAGS=\"$CXXFLAGS -arch i386\" ./configure --disable-dependency-tracking --prefix=#{prefix} #{pgm_flags}"
    system "make"
    system "mv src/.libs src/libs-32"
    system "make clean"

    # make 64-bit
    system "CFLAGS=\"$CFLAGS -arch x86_64\" CXXFLAGS=\"$CXXFLAGS -arch x86_64\" ./configure --disable-dependency-tracking --prefix=#{prefix} #{pgm_flags}"
    system "make"
    system "mv src/.libs/libzmq.1.dylib src/.libs/libzmq.64.dylib"

    # merge UB
    system "lipo", "-create", "src/libs-32/libzmq.1.dylib", "src/.libs/libzmq.64.dylib", "-output", "src/.libs/libzmq.1.dylib"
  end

  def install
    system "./autogen.sh" if ARGV.build_head?

    if ARGV.build_universal?
      build_fat
    else
      args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
      args << "--with-pgm" if ARGV.include? '--with-pgm'
      system "./configure", *args
    end

    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To install the zmq gem on 10.6 with the system Ruby on a 64-bit machine,
    you may need to do:

        ARCHFLAGS="-arch x86_64" gem install zmq -- --with-zmq-dir=#{HOMEBREW_PREFIX}

    If you want to build the Java bindings from https://github.com/zeromq/jzmq
    you will need the Java Developer Package from http://connect.apple.com/
    EOS
  end
end

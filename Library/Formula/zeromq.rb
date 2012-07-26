require 'formula'

def pgm_flags
  return ARGV.include?('--with-pgm') ? "--with-pgm" : ""
end

class Zeromq < Formula
  homepage 'http://www.zeromq.org/'
  url 'http://download.zeromq.org/zeromq-2.2.0.tar.gz'
  md5 '1b11aae09b19d18276d0717b2ea288f6'
  head 'https://github.com/zeromq/libzmq.git'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  fails_with :llvm do
    build 2326
    cause "Segfault while linking"
  end

  def options
    [
      ['--with-pgm', 'Build with PGM extension'],
      ['--universal', 'Build as a Universal Intel binary.']
    ]
  end

  def build_fat
    # make 32-bit
    system "CFLAGS=\"$CFLAGS -arch i386\" CXXFLAGS=\"$CXXFLAGS -arch i386\" ./configure --disable-dependency-tracking --prefix='#{prefix}' #{pgm_flags}"
    system "make"
    system "mv src/.libs src/libs-32"
    system "make clean"

    # make 64-bit
    system "CFLAGS=\"$CFLAGS -arch x86_64\" CXXFLAGS=\"$CXXFLAGS -arch x86_64\" ./configure --disable-dependency-tracking --prefix='#{prefix}' #{pgm_flags}"
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

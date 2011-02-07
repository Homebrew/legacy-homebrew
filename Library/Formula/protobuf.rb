require 'formula'

class Protobuf <Formula
  url 'http://protobuf.googlecode.com/files/protobuf-2.3.0.tar.bz2'
  sha1 'db0fbdc58be22a676335a37787178a4dfddf93c6'
  homepage 'http://code.google.com/p/protobuf/'

  def install
    fails_with_llvm
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"

    ['Makefile', 'src/Makefile'].each do |mk|
      inreplace mk do |s|
        existing = s.get_make_var 'CXXFLAGS'
        s.change_make_var! 'CXXFLAGS', existing + ' -arch i386 -arch x86_64'
      end
    end

    system "make"
    system "make install"
  end
end

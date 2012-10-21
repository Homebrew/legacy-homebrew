require 'formula'

class Szl < Formula
  homepage 'http://code.google.com/p/szl/'
  url 'http://szl.googlecode.com/files/szl-1.0.tar.gz'
  sha1 'e4c6d4aec1afc025257d41dd77b8f5c25ea120d4'

  depends_on 'binutils' # For objdump
  depends_on 'icu4c'
  depends_on 'protobuf' # for protoc
  depends_on 'pcre'

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      engine/symboltable.cc:47:7: error: qualified reference to 'Proc' is a constructor name rather than a type wherever a constructor can be declared
      Proc::Proc* SymbolTable::init_proc_ = NULL;
    EOS
  end

  def install
    ENV['OBJDUMP'] = "#{HOMEBREW_PREFIX}/bin/gobjdump"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

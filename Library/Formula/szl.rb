require 'formula'

class Szl < Formula
  homepage 'http://code.google.com/p/szl/'
  url 'http://szl.googlecode.com/files/szl-1.0.tar.gz'
  md5 'd25f73b2adf4b92229d8b451685506d1'

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

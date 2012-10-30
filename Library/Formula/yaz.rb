require 'formula'

class Yaz < Formula
  homepage 'http://www.indexdata.com/yaz'
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-4.2.44.tar.gz'
  sha1 'cd1f2275dc43e104dcb92c515a4264ea3c161a6e'

  depends_on 'pkg-config' => :build

  def install
    # Both libxml2 2.7.3 and icu are defined the same data type `UChar'.
    ENV.append_to_cflags "-Wno-typedef-redefinition" if ENV.compiler == :clang

    if (ENV.compiler == :gcc or ENV.compiler == :llvm) and build.include? "env=std"
      opoo <<-EOS.undent
        GCC and LLVM-GCC can't build with icu and system's libxml together.
        If you have request about this and have Clang, you can compile it with:
          brew install yaz --env=std --use-clang
      EOS
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make install"
  end
end

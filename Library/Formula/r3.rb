require "formula"

class R3 < Formula
  homepage "https://github.com/c9s/r3"
  url 'https://github.com/c9s/r3/archive/1.3.2.tar.gz'
  sha1 '99837a42b637e32cd634a5fbdaeaf519a2df5dc5'

  option "with-graphviz", "Enable Graphviz functions"

  head "https://github.com/c9s/r3.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "graphviz" => :optional
  depends_on "jemalloc" => :recommended

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh"
    args = %W{
      --prefix=#{prefix}
    }

    args << "--enable-graphviz" if build.with? "graphviz"
    args << "--with-malloc=jemalloc" if build.with? "jemalloc"

    system "./configure", *args
    system "make install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "r3.h"
      int main() {
          node * n = r3_tree_create(1);
          r3_tree_free(n);
          return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-lr3", "-I#{include}/r3"
    system "./test"
  end
end

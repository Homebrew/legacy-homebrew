require "formula"

class R3 < Formula
  homepage "https://github.com/c9s/r3"
  url 'https://github.com/c9s/r3/archive/1.3.2.tar.gz'
  sha1 '99837a42b637e32cd634a5fbdaeaf519a2df5dc5'

  bottle do
    cellar :any
    sha1 "16475109c374517ee2e2883a46015622a758ef44" => :mavericks
    sha1 "75b212352a81faa87c59f6400a98b3946e896ee9" => :mountain_lion
    sha1 "786d3cfeb350f7b5bc8b17a3d411ac5ef6b8c85f" => :lion
  end

  option :universal
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
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
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

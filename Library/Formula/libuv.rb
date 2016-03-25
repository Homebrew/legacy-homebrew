class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.8.0.tar.gz"
  sha256 "906e1a5c673c95cb261adeacdb7308a65b4a8f7c9c50d85f3021364951fa9cde"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "a34b88cfbbe193271251130ea7a3b20469dbe3f83c3ba3f911c1447d5499348b" => :el_capitan
    sha256 "60b8e218282f2e054964037e23fb8beeef20fb2475c03d40cf07050688e5f0fd" => :yosemite
    sha256 "c24fb05674c293a89b7855ba045a3094edb6a3acee5527acd11564e2e4499ed9" => :mavericks
  end

  option "without-docs", "Don't build and install documentation"
  option "with-test", "Execute compile time checks (Requires Internet connection)"
  option :universal

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"

  def install
    ENV.universal_binary if build.universal?

    if build.with? "docs"
      # This isn't yet handled by the make install process sadly.
      cd "docs" do
        system "make", "man"
        system "make", "singlehtml"
        man1.install "build/man/libuv.1"
        doc.install Dir["build/singlehtml/*"]
      end
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-luv", "-o", "test"
    system "./test"
  end
end

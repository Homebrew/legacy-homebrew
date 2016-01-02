class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.23.4.tar.gz"
  sha256 "c7f5e2d7381dbc4d7e878013d14f9993ae8a41bd23f032718e39ffba57894029"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "4f0c2aec775dc8d87a7c8353fc9b20dd0ecb3bcce09f26d384b415f53b86d706" => :el_capitan
    sha256 "fdd7a4f56d3ce6944a188eeab2ec6f3cc15ce9013cb9d2d35ccfe81f9dc41bd5" => :yosemite
    sha256 "f550ac6e9da577df0ba53e4ec6c2158632c6957219e7fa6f805f72714042d8e2" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libssh2" => :optional
  depends_on "openssl" if MacOS.version <= :lion # Uses SecureTransport on >10.7

  def install
    args = std_cmake_args
    args << "-DBUILD_CLAR=NO" # Don't build tests.
    args << "-DUSE_SSH=NO" if build.without? "libssh2"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <git2.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

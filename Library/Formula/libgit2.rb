class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.22.3.tar.gz"
  sha256 "511fe60e7c12c3525b4e0489861e5c1fe0e331d604bee9a3dfb8420c2f288f60"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "ecc9a5697ee9834c5c35d849331315ebf39565b9272b0e5cce155ec23507735b" => :yosemite
    sha256 "1653516e194defec8bb954e0e59edb15cf76bb7efa609f0bf11ca95dc7b600e8" => :mavericks
    sha256 "4aa576564a09b3053585d63498ad02553374975dd526f9faaf50c982af0d3da6" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "libssh2" => :optional
  depends_on "openssl"

  def install
    args = std_cmake_args
    args << "-DBUILD_CLAR=NO" # Don't build tests.

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

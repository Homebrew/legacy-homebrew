class Tcc < Formula
  desc "Tiny C compiler"
  homepage "http://bellard.org/tcc/"
  url "http://download.savannah.gnu.org/releases/tinycc/tcc-0.9.26.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/tcc-0.9.26.tar.bz2"
  sha256 "521e701ae436c302545c3f973a9c9b7e2694769c71d9be10f70a2460705b6d71"

  bottle do
    sha256 "6361d686961e63328e2e084e346df9a0f3bea8f4c1aa7a48b627b528b76b5622" => :yosemite
    sha256 "d933047b24c74dc83fad767b8838ded95c1b512846960144c6442480410038eb" => :mavericks
    sha256 "a08aa7da0eccb7c93414fd4944ce5676248869da5f62810bbe687704ba37807d" => :mountain_lion
  end

  option "with-cross", "Build all cross compilers"

  def install
    args = %W[
      --prefix=#{prefix}
      --source-path=#{buildpath}
      --sysincludepaths=/usr/local/include:#{MacOS.sdk_path}/usr/include:{B}/include
    ]

    args << "--enable-cross" if build.with? "cross"

    ENV.j1
    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "test"
  end

  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/tcc -run hello-c.c")
  end
end

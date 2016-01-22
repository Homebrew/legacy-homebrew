class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  homepage "http://concurrencykit.org"
  url "http://concurrencykit.org/releases/ck-0.5.1.tar.gz"
  mirror "https://github.com/concurrencykit/ck/archive/0.5.1.tar.gz"
  sha256 "efeebda38d68a7c194a4632e842987f03be58f2f910f0745a56f0ae7d9a1dac5"

  head "https://github.com/concurrencykit/ck.git"

  bottle do
    cellar :any
    sha256 "de655fd0b4affb14f53d1f793ab8f783548cb18edda6874cc94fd5c077dd514a" => :el_capitan
    sha256 "1aff7b9466a5c1fb28f34166fa1eec8d0bab57d2c0908bdf8437dc114d5283f0" => :yosemite
    sha256 "c9edc8f8f8599f6cba80aaa94a4f30c7c3e4def915bf34e18ec2927f0d5f4072" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ck_spinlock.h>
      int main()
      {
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lck",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end

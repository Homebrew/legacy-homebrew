class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "http://cpptest.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-1.1.2/cpptest-1.1.2.tar.gz"
  sha256 "9e4fdf156b709397308536eb6b921e3aea1f463c6613f9a0c1dfec9614386027"

  bottle do
    cellar :any
    revision 1
    sha256 "216442c844ddb2886e6877cd129fda3c589dadf8ac07572e6aa05c1c3cff4669" => :el_capitan
    sha256 "e6b364e203c882063362e4a0ef6e6482420ab57b1ec24699b6da31b50f792f14" => :yosemite
    sha256 "c1f68d40bd58366d28846395169868d86a012b8d65473aa8845401619052d568" => :mavericks
    sha256 "a3f5cf0532bf9b72b73bf2fa52862b88fbc318ebd0ee9712a09771a071371fbc" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <cpptest.h>

      class TestCase: public Test::Suite
      {
      public:
        TestCase() { TEST_ADD(TestCase::test); }
        void test() { TEST_ASSERT(1 + 1 == 2); }
      };

      int main()
      {
        TestCase ts;
        Test::TextOutput output(Test::TextOutput::Verbose);
        assert(ts.run(output));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lcpptest", "-o", "test"
    system "./test"
  end
end

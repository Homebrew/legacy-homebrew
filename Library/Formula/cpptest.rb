class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "http://cpptest.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-1.1.2/cpptest-1.1.2.tar.gz"
  sha256 "9e4fdf156b709397308536eb6b921e3aea1f463c6613f9a0c1dfec9614386027"

  bottle do
    cellar :any
    revision 1
    sha1 "5848e63c76547c2caada10bc0c13a8fe5fe57ac3" => :yosemite
    sha1 "690ac2342b37b3849da30d289e04c13e1430db3e" => :mavericks
    sha1 "ec143d787f9f5dd0ba295d1fbb80c1a7d54fa780" => :mountain_lion
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

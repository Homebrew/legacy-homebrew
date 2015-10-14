class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "04e13af1e255cd8eb0e954a0d4922822cc49418bbe9f1dd8b488a6c07d6edd03" => :yosemite
    sha256 "9fcb3f583f39b58926c4010be7471240a72587339a1ae44af57d6c5301218523" => :mavericks
  end

  depends_on :macos => :mavericks

  depends_on "gflags"
  depends_on "glog"
  depends_on "libxml2"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "v8"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"sample_test.js").write <<-EOF
      function SampleTest() {
      }
      registerTestSuite(SampleTest);

      addTest(SampleTest, function twoPlusTwoEqualsFour() {
        expectEq(4, 2+2);
      });
    EOF

    system "#{bin}/gjstest", "--js_files", "#{testpath}/sample_test.js"
  end
end

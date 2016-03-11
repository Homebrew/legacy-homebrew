class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 2

  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "3d163ee60a23ec3b70dc0da03c16c7515b897aa8e1485ab2571d961ccd79a425" => :el_capitan
    sha256 "d9ff351be0d6596011db1e36593ad9173e23cf484c9036aa999af1ef0eb2ab31" => :yosemite
    sha256 "d9236d81466408f87673d574927366059ad1bbb9f37a9e3660565fd7edcd4351" => :mavericks
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

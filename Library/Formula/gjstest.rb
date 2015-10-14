class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "bfcf81248ee22cdf1cc7c469a8b6c31cab40e9661c376cda708cf2daedf4e13e" => :el_capitan
    sha256 "93eb101695f858024d64b682dbd4557bd43dc836701826389344768569be9570" => :yosemite
    sha256 "79a6bf7fb9d74871911d47012c2bb643ebb4870d0ab616dad7a19171414df291" => :mavericks
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

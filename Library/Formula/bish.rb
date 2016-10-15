class Bish < Formula
  homepage "https://github.com/tdenniston/bish"
  url "https://github.com/tdenniston/bish/archive/v0.1.tar.gz"
  sha256 "796d1efcbc9e8c7ea604881860aa8d857aad089c4eeb766283c21c210687942b"

  def install
    stdlib_path = share/"stdlib.bish"
    share.install "lib/stdlib.bish"
    system "make", "-e", "CONFIG_CONSTANTS=-DSTDLIB_PATH=\"\\\"#{stdlib_path}\\\"\""
    bin.install "bish"
  end

  test do
    (testpath/"test.bish").write <<-EOS.undent
      def test() {
        print("OK");
      }
      test();
    EOS
    require "open3"
    Open3.popen3("#{bin}/bish", "-r", testpath/"test.bish") do |stdin, stdout, _|
      stdin.close
      assert_equal "OK", stdout.read
    end
  end
end

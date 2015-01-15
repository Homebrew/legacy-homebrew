class UcspiTools < Formula
  homepage "https://github.com/younix/ucspi/blob/master/README.md"
  url "https://github.com/younix/ucspi/archive/7c59e7649cbce470452116595b5c00a26840d4cf.tar.gz"
  sha1 "cd3ae141b8d3e7783564ad5c3f2566f8d6fb5c82"
  version "1.1"

  depends_on "pkg-config" => :build
  depends_on "ucspi-tcp"
  depends_on "libressl"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    `#{bin}/socks`
    assert_equal 1, $?.exitstatus
  end
end

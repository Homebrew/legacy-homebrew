class UcspiTools < Formula
  homepage "https://github.com/younix/ucspi/blob/master/README.md"
  url "https://github.com/younix/ucspi/archive/v1.1.tar.gz"
  sha1 "9196a1033f3131a888acf091d0acbc1a83a02702"

  depends_on "pkg-config" => :build
  depends_on "ucspi-tcp"
  depends_on "libressl"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = `#{bin}/socks`
    assert_equal 1, $?.exitstatus
  end
end

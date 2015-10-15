class Smc < Formula
  desc "Apple System Management Control (SMC) Tool"
  homepage "https://github.com/yoshida-mediba/smc"
  url "https://github.com/yoshida-mediba/smc/archive/0.01_2.tar.gz"
  sha256 "964c7ddbc5e448a996e7ef9d2dfd580cc32d6a327b73047b3f73c7e6465158e3"

  def install
    system "make"
    system "make", "install", "INSTALL_PATH=#{prefix}"
  end

  test do
    system "#{bin}/smc", "-v"
  end
end

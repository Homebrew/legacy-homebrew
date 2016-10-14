class Smc < Formula
  desc "Apple System Management Control (SMC) Tool"
  homepage "https://github.com/yoshida-mediba/smc"
  url "https://github.com/yoshida-mediba/smc/archive/v0.1.tar.gz"
  sha256 "d7f066e39d3350cfdb2c9e76315ba17985084c51172dc2f54dc81c76e51fd0e2"

  def install
    system "make"
    system "make", "install", "INSTALL_PATH=#{prefix}"
  end

  test do
    system "#{bin}/smc", "-v"
  end
end

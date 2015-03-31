class I2cssh < Formula
  homepage "https://github.com/djui/i2cssh"
  head "https://github.com/djui/i2cssh.git"
  url "https://github.com/djui/i2cssh/archive/1.0.tar.gz"
  sha256 "25d39f917fac90b374a57fd0c525a53b9d1355415004a1c279f34a60219fa56a"

  def install
    bin.install "i2cssh"
  end

  test do
    system "#{bin}/i2cssh"
  end
end

class Giti < Formula
  desc "Super awesome git initialization script!"
  homepage "https://github.com/kevcooper/giti"
  url "https://github.com/kevcooper/giti/archive/v1.0.tar.gz"
  head "https://github.com/kevcooper/giti.git"
  sha256 "24216a3ce4df46f8e37455a474afd4dc3bd2cf1e78d1c942a63119044c6c5e14"

  def install
    bin.install "giti"
  end

  test do
    system "#{bin}/giti", "--help"
  end
end

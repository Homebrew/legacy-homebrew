class H2object < Formula
  desc "another fast & flexible static website generator & deployment tool"
  homepage "https://github.com/h2object/h2object"
  url "http://dl.h2object.io/h2object/macosx/1.0.0.tar.gz"
  sha256 "2b9df7547876dcf24c4b0b39568b2da0198b6102960d41e522994a0e4ab060c6"

  def install
    bin.install "h2object"
  end

  test do
    system "#{bin}/h2object", "-h"
  end
end

class H2object < Formula
  homepage "http://h2object.io"
  url "http://dl.h2object.io/h2object/macosx/1.0.0.tar.gz"
  sha256 "2b9df7547876dcf24c4b0b39568b2da0198b6102960d41e522994a0e4ab060c6"        
  desc "the most fasting http server with themes to build web application"

  def install
    bin.install "h2object"
  end

  test do
    system "#{bin}/h2object", "-h"
  end
end

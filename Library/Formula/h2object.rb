class H2object < Formula
  homepage "http://h2object.io"
  url "http://dl.h2object.io/h2object/macosx/h2object-0.0.1.tar.gz"
  sha256 "262f2f491baca8c06f600f2c94506592a08cbfc6fede51e53586b58d3e8c0fe5"
  desc "the most fasting http server with themes to build web application"

  def install
    bin.install "h2object"
  end

  test do
    system "#{bin}/h2object", "-h"
  end
end

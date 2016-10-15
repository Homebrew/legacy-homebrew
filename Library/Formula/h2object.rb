class H2object < Formula
  desc "another fast & flexible static website generator & deployment tool"
  homepage "https://github.com/h2object/h2object"
  url "http://dl.h2object.io/h2object/macosx/1.0.1.tar.gz"
  sha256 "b9a13a52a3881ec6aca3dfd42b169f181ca3bed8e56b2a82695f5f72dc1ea2ce"

  def install
    bin.install "h2object"
  end

  test do
    system "#{bin}/h2object", "-h"
  end
end

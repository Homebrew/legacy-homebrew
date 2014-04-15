require "formula"

class Restli < Formula
  homepage "http://rest.li/"
  url "http://rest.li/releases/restli-tool/0.0.1/restli-0.0.1.tar.gz"
  sha1 "1b11f3012d112f63250f5721dd82a501b1e42014"

  depends_on "giter8"

  def install
    bin.install 'restli'
  end

  test do
    system "#{bin}/restli"
  end
end

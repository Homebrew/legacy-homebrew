require "formula"


class Odb < Formula
  homepage "http://www.codesynthesis.com/products.odb"
  url "http://www.codesynthesis.com/download/odb/2.3/odb-2.3.0-i686-macosx.tar.bz2"
  sha1 "7bdde23582d8e6f57d5a2fffd9fa77ab35de5bcc"

  def install
      bin.install Dir["bin/*"]
      doc.install Dir["doc/*"]
      man.install Dir["man/*"]
      lib.install Dir["lib/*"]
      etc.install Dir["etc/*"]
      prefix.install "README"
  end
end

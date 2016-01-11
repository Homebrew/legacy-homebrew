class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.cybercom.net/~dcoffin/dcraw/"
  url "https://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-9.26.0.tar.gz"
  sha256 "85791d529e037ad5ca09770900ae975e2e4cc1587ca1da4192ca072cbbfafba3"

  bottle do
    cellar :any
    revision 1
    sha256 "b30d2dffb7edf644f1713626d2e01e1485d7089e58421c84f94e9e0fc7d86695" => :el_capitan
    sha256 "0ce10a8ec1115adf1e7105231cb39c67ab43842d282dda1df58d2f7d0fb160f7" => :yosemite
    sha256 "ac71978f16ef81b3b20e61785a7f015a576802c7c1e601f8677a2edb2b3c869d" => :mavericks
  end

  depends_on "jpeg"
  depends_on "jasper"
  depends_on "little-cms2"

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system ENV.cc, "-o", "dcraw", ENV.cflags, "dcraw.c", "-lm", "-ljpeg", "-llcms2", "-ljasper"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end
end

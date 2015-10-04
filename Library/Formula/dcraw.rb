class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.cybercom.net/~dcoffin/dcraw/"
  url "https://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-9.26.0.tar.gz"
  sha256 "85791d529e037ad5ca09770900ae975e2e4cc1587ca1da4192ca072cbbfafba3"

  bottle do
    cellar :any
    sha256 "b4fff769c26b35834bf4996164577e71d242ab52a925f600e0774da4dffa5102" => :yosemite
    sha256 "a20cf18c984fe285f3196d7df3f5b623b857a18f024b122959974777c4e1c7d8" => :mavericks
    sha256 "c653cd57a595fe076eaa5f602473c5d9276f3776b1caf3c273af175f024ad977" => :mountain_lion
  end

  depends_on "jpeg"
  depends_on "jasper"
  depends_on "little-cms2"

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system "#{ENV.cc} -o dcraw #{ENV.cflags} dcraw.c -lm -ljpeg -llcms2 -ljasper"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end
end

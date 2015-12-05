class Exiftags < Formula
  desc "Utility to read EXIF tags from a digital camera JPEG file"
  homepage "http://johnst.org/sw/exiftags"
  url "http://johnst.org/sw/exiftags/exiftags-1.01.tar.gz"
  sha256 "d95744de5f609f1562045f1c2aae610e8f694a4c9042897a51a22f0f0d7591a4"

  bottle do
    cellar :any
    sha256 "23a94f2c2694d52ef393e751e23a01c4ed23c0ca7004b6597546047310e73f53" => :yosemite
    sha256 "2ca339b45b3ea518ca5b39262b4c68cc54187a2bfca7d7a52eded5685c81b3c9" => :mavericks
    sha256 "d5c5f565b2b7f0d6f7161801680095c6fefb3c7234cb9a9046a263dd8d983cff" => :mountain_lion
  end

  def install
    bin.mkpath
    man1.mkpath
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    system "#{bin}/exiftags", test_fixtures("test.jpg")
  end
end

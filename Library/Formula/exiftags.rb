class Exiftags < Formula
  desc "Utility to read EXIF tags from a digital camera JPEG file"
  homepage "http://johnst.org/sw/exiftags"
  url "http://johnst.org/sw/exiftags/exiftags-1.01.tar.gz"
  sha1 "06636feb7d5c5835da01d5da8cd0f4a291d23fd8"

  bottle do
    cellar :any
    sha1 "f798eb88c317e58eb1d37c1da9f4755d9a6f478c" => :yosemite
    sha1 "5dbb67622e47f1b1cdc3e9810ad84dc2d4746ae3" => :mavericks
    sha1 "a427dbfca42716ba54f26d8f2c9d5cbe543dc8bc" => :mountain_lion
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

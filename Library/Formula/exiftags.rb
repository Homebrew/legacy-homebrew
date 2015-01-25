class Exiftags < Formula
  homepage "http://johnst.org/sw/exiftags"
  url "http://johnst.org/sw/exiftags/exiftags-1.01.tar.gz"
  sha1 "06636feb7d5c5835da01d5da8cd0f4a291d23fd8"

  def install
    bin.mkpath
    man1.mkpath
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    system "#{bin}/exiftags", test_fixtures("test.jpg")
  end
end

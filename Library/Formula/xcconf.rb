class Xcconf < Formula
  homepage "https://github.com/AlexDenisov/xcconf"
  url "https://github.com/AlexDenisov/xcconf/archive/0.1.2.tar.gz"
  sha1 "18207958ebe7c2f8401e75ecb9afcd74e4418027"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/xcconf", "2>&1", "|", "grep", "-q", "INPUT_FILE_PATH"
  end
end

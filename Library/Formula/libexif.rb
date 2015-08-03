class Libexif < Formula
  desc "EXIF parsing library"
  homepage "http://libexif.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libexif/libexif/0.6.21/libexif-0.6.21.tar.gz"
  sha256 "edb7eb13664cf950a6edd132b75e99afe61c5effe2f16494e6d27bc404b287bf"

  bottle do
    cellar :any
    revision 1
    sha1 "7fd580b7289a4d3ace04575ed44e8005feb63691" => :yosemite
    sha1 "170009ee38c18d24a06a6ab0bf2c957cf8b378c2" => :mavericks
    sha1 "4af9a9537c52e59594d313b8decbffc0b12fbf7a" => :mountain_lion
  end

  fails_with :llvm do
    build 2334
    cause "segfault with llvm"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end

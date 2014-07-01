require "formula"

class Xorriso < Formula
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.3.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.3.8.tar.gz"
  sha1 "e16757413ad06f3295b27d30e5a3604bd8c2c606"

  bottle do
    cellar :any
    sha1 "be075d21843fa8134448d7c964a74ff5b7ae376a" => :mavericks
    sha1 "9e9fbc27e1c88493b279a0d6b6429610edf27916" => :mountain_lion
    sha1 "b135a141f02d669c70427db2bfacff8f7db06ad4" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/xorriso", "--help"
  end
end

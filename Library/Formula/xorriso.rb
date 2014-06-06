require "formula"

class Xorriso < Formula
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.3.6.pl01.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.3.6.pl01.tar.gz"
  sha1 "b9d8f38726993e707c7bb512c73e591644905e9c"
  version "1.3.6.pl01"

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

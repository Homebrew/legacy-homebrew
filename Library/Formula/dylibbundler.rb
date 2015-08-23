class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for OS X"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://downloads.sourceforge.net/project/macdylibbundler/macdylibbundler/0.4.4/dylibbundler-0.4.4.zip"
  sha256 "65d050327df99d12d96ae31a693bace447f4115e6874648f1b3960a014362200"
  head "https://github.com/auriamg/macdylibbundler.git"

  bottle do
    cellar :any
    revision 1
    sha1 "7796af4a80af52b2cda87f9a6af74919811cddb4" => :yosemite
    sha1 "af56868cede7747f2559320659654e017cb0144a" => :mavericks
    sha1 "81c315d6fbaea3b56ba78e967953f3f8a11d08ec" => :mountain_lion
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end

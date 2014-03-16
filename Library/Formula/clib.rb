require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.1.1.tar.gz"
  sha1 "0b4c59f7f281e8c43d212e789b7b7c81002301e3"

  bottle do
    cellar :any
    revision 1
    sha1 "530dbba3d513eaa7284a7599a9e5c9b5661e49b8" => :mavericks
    sha1 "3a5752cfabec9ba1be40264e921156be5a8322e3" => :mountain_lion
    sha1 "257551cef879d27bade529a36ae035fe19775f38" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end

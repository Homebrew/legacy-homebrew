require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.0.0.tar.gz"
  sha1 "d840b4259190e1b3ce6cc0970f3e9f659226b9d3"

  def patches
    # Fix exit codes.
    "https://github.com/clibs/clib/commit/000a5a.patch"
  end

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

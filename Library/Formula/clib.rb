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
    sha1 "b533a51036f0013496bf8ca8a5039d0a705436f9" => :mavericks
    sha1 "26d64bc906d6487f1009917f19deb7ad859ccb36" => :mountain_lion
    sha1 "c963615301797d63ca65e927432173a5fbb33d24" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end

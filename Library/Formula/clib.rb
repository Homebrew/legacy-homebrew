require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.1.6.tar.gz"
  sha1 "6b9711b594f3aff8c4a8a4aefac926c8d0f8555c"

  bottle do
    cellar :any
    sha1 "2aa6a8ec8df9369e2894d5a85f7fa443dd7b6f32" => :mavericks
    sha1 "424f867ecffa2fc25e61d92fc907dd6f731c3b8d" => :mountain_lion
    sha1 "894358ebf124ff03e5918673426346072523bcbf" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end

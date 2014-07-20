require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.2.2.tar.gz"
  sha1 "e103638102f33cb38308d6f108feea9f0daff08a"

  bottle do
    cellar :any
    sha1 "c44bb17e2429ee6b3b25dc23c118ea612b3fe51c" => :mavericks
    sha1 "5966db2ded69b2d28cea1e44fa2b629fd4a8f28f" => :mountain_lion
    sha1 "a146278fa12562ead2333d4bb76c2ef17ecaa776" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end

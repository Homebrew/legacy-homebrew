require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.2.2.tar.gz"
  sha1 "e103638102f33cb38308d6f108feea9f0daff08a"

  bottle do
    cellar :any
    revision 1
    sha1 "34cd018a5a3b85899d246574eb653246a929c848" => :yosemite
    sha1 "15a82cf9553ac9c8eff6a6cc309661b55327c710" => :mavericks
    sha1 "c6d984954c4faee1cfa9daba196e77830fdcfd46" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end

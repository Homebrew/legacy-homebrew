class Aterm < Formula
  desc "AfterStep terminal emulator"
  homepage "http://strategoxt.org/Tools/ATermFormat"
  url "http://www.meta-environment.org/releases/aterm-2.8.tar.gz"
  sha256 "bab69c10507a16f61b96182a06cdac2f45ecc33ff7d1b9ce4e7670ceeac504ef"

  bottle do
    cellar :any
    sha1 "4854b5dbb4b3823f940687183278bf9eea4314ea" => :mavericks
    sha1 "f8158deddace1854f75723d864a69e51e3fb9c3f" => :mountain_lion
    sha1 "bc701fbb4fac832f2b1662a2d3cab506f6b72798" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV.j1 # Parallel builds don't work
    system "make", "install"
  end
end

require "formula"

class Fswatch < Formula
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.0/fswatch-1.4.0.zip"
  sha1 "12031348b0afcc12105c63271aa57e599fc9ab94"

  bottle do
    sha1 "4f002ffcb2a2c1fa93c1eb1976b12e6eed38304f" => :mavericks
    sha1 "6d920dae8c0086e7a2cfadd1ed949baee055a208" => :mountain_lion
    sha1 "3bb0ac74a32cd00429bef19b088687e4ff836307" => :lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end

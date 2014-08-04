require "formula"

class Fswatch < Formula
  homepage "https://github.com/alandipert/fswatch"
  url "https://github.com/alandipert/fswatch/archive/1.3.9.tar.gz"
  sha1 "5035f9f3ece9b64f523f62e47edaf791f305a424"

  bottle do
    sha1 "4f002ffcb2a2c1fa93c1eb1976b12e6eed38304f" => :mavericks
    sha1 "6d920dae8c0086e7a2cfadd1ed949baee055a208" => :mountain_lion
    sha1 "3bb0ac74a32cd00429bef19b088687e4ff836307" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end

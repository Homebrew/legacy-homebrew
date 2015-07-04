class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.1p0/owfs-3.1p0.tar.gz"
  version "3.1p0"
  sha256 "62fca1b3e908cd4515c9eb499bf2b05020bbbea4a5b73611ddc6f205adec7a54"

  bottle do
    cellar :any
    sha256 "97c0ad182ab7c5f000ed8734272be3a0aac38cf6df9cb7bb2e0f67825cf0a717" => :yosemite
    sha256 "5682fed7463f0c20636a6fb961ff4edde845a497b55618eaff2d986613e09e20" => :mavericks
    sha256 "f71d3106d44a4afd36a8d19057da893528e85c528a5727cc1ed278db0e44da2e" => :mountain_lion
  end

  depends_on "libusb-compat"

  def install
    # Fix include of getline and strsep to avoid crash
    inreplace "configure", "-D_POSIX_C_SOURCE=200112L", ""

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owfs",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/owserver", "--version"
  end
end

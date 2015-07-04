class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.1p0/owfs-3.1p0.tar.gz"
  version "3.1p0"
  sha256 "62fca1b3e908cd4515c9eb499bf2b05020bbbea4a5b73611ddc6f205adec7a54"

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

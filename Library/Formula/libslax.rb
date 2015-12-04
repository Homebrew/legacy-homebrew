class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.19.0/libslax-0.19.0.tar.gz"
  sha256 "a80e88709459791a3193ee665d7272109c61aa3e717c68bc95a29e6718ae2191"

  bottle do
    revision 1
    sha256 "9faa71033a275aeb2b232543ad61ef09fe069ece4794cc28d2c03b8cd83dc9b5" => :yosemite
    sha256 "5108fa8d5db98f2a8441bb90c860ea01302afe935089be162f6a5164aa56fedd" => :mavericks
    sha256 "a29d332d5fd18e9903e891018ed8c3f527efc7fe95029e219b3d5e1e4e4a5c47" => :mountain_lion
  end

  head do
    url "https://github.com/Juniper/libslax.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool"  => :build

  if MacOS.version <= :mountain_lion
    depends_on "libxml2"
    depends_on "libxslt"
  end

  depends_on "curl" if MacOS.version <= :lion

  def install
    system "sh", "./bin/setup.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end
end

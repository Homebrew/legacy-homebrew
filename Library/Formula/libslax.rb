class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.19.0/libslax-0.19.0.tar.gz"
  sha256 "a80e88709459791a3193ee665d7272109c61aa3e717c68bc95a29e6718ae2191"

  bottle do
    revision 1
    sha1 "487cc4e9ae3369e3dc0e6b9ba69de00c5918abe2" => :yosemite
    sha1 "0ddfdfd5b04da4c6199486643a4bcbfc3a60d5b5" => :mavericks
    sha1 "a30b683ea6284c6e927b37030ab104071180e212" => :mountain_lion
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

class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "http://pupnp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.19/libupnp-1.6.19.tar.bz2"
  sha256 "b3142b39601243b50532eec90f4a27dba85eb86f58d4b849ac94edeb29d9b22a"

  bottle do
    cellar :any
    revision 1
    sha1 "52432174b87b12486f78f8d4c45d0ac7b23e11eb" => :yosemite
    sha1 "09c01a27803cc08266a601e401b9556f87e760d3" => :mavericks
  end

  option "with-ipv6", "Enable IPv6 support"

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"
           ]

    args << "--enable-ipv6" if build.with? "ipv6"

    system "./configure", *args
    system "make", "install"
  end
end

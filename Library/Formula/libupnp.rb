class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "http://pupnp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.19/libupnp-1.6.19.tar.bz2"
  sha256 "b3142b39601243b50532eec90f4a27dba85eb86f58d4b849ac94edeb29d9b22a"

  bottle do
    cellar :any
    revision 1
    sha256 "d15eed74f72a97b797db6f3ae23182f56c8dc5bfd4c0f7746fe245d927884b8e" => :yosemite
    sha256 "deb2e1d0ef15fa03e9f27c3726e81fd9eb8392ab6463ab90fef191f04492a9ce" => :mavericks
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

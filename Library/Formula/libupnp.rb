class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "http://pupnp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.19/libupnp-1.6.19.tar.bz2"
  sha256 "b3142b39601243b50532eec90f4a27dba85eb86f58d4b849ac94edeb29d9b22a"

  bottle do
    cellar :any
    revision 2
    sha256 "8300a8d89071475837506bea964cdba143144186dad0943e4d8c722c799e3857" => :el_capitan
    sha256 "29d9a4c05dcfd083b3538110d7a5089143399cb05670574761dda81d3b9c8ac7" => :yosemite
    sha256 "ac9e828723689c2d91b6f046baca02baa1a653caacfe071aa5add056e1f2381b" => :mavericks
  end

  option "with-ipv6", "Enable IPv6 support"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-ipv6" if build.with? "ipv6"

    system "./configure", *args
    system "make", "install"
  end
end

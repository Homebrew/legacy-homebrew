class Libelf < Formula
  desc "ELF object file access library"
  homepage "http://www.mr511.de/software/"
  url "http://www.mr511.de/software/libelf-0.8.13.tar.gz"
  sha256 "591a9b4ec81c1f2042a97aa60564e0cb79d041c52faa7416acb38bc95bd2c76d"

  bottle do
    cellar :any
    revision 1
    sha1 "58ec51e663fa6375026ff609c1c189f870559d0c" => :yosemite
    sha1 "0eeb37ce876f79cc0261cfd9c6ec9cfd8bc5c28b" => :mavericks
    sha1 "a62370107719d8a92b0226335cd9dd73686ddd4f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-compat"
    # Use separate steps; there is a race in the Makefile.
    system "make"
    system "make", "install"
  end
end

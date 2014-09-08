require 'formula'

class Libcec < Formula
  homepage 'http://libcec.pulse-eight.com/'
  url 'https://github.com/Pulse-Eight/libcec/archive/libcec-2.1.4.tar.gz'
  sha1 '3ee241201b3650b97ec4fc41b0f5dd33476080f9'

  bottle do
    cellar :any
    sha1 "2e3d47fd5de28a92572fc112ef28f64f02a25d0b" => :mavericks
    sha1 "b926b847e6a6bd53d42b0af7317846fb73ce20b2" => :mountain_lion
    sha1 "ab69ed933cb155203a69683e8a4ef4248d87d589" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/cec-client", "--info"
  end
end

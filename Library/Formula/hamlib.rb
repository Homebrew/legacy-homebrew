class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://hamlib.sourceforge.net"
  url "http://pkgs.fedoraproject.org/repo/pkgs/hamlib/hamlib-1.2.15.3.tar.gz/3cad8987e995a00e5e9d360e2be0eb43/hamlib-1.2.15.3.tar.gz"
  sha256 "a2ca4549e4fd99d6e5600e354ebcb57502611aa63c6921c1b8a825289833f75e"

  bottle do
    revision 1
    sha256 "d4e86dbc6d9bf5e0b4a1c1bce2471e90becf05b19b1c595952c94b3bda91e0db" => :el_capitan
    sha256 "31a75a43cf17a17d35ee0c57048522e73de7c69f43279b45c766a903b5239372" => :yosemite
    sha256 "6d9dd131db4baa70355822033257f822e029aa167b6c43643419bd75ef06395a" => :mavericks
    sha256 "0e78439f806f68ae1ae36fa3e5315d13cbabf6da714571eec9816945a90b2985" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end

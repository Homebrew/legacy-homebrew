class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.8.1/libaacs-0.8.1.tar.bz2"
  mirror "http://videolan-nyc.defaultroute.com/libaacs/0.8.1/libaacs-0.8.1.tar.bz2"
  sha256 "95c344a02c47c9753c50a5386fdfb8313f9e4e95949a5c523a452f0bcb01bbe8"

  bottle do
    cellar :any
    revision 1
    sha256 "9c7aed37c3991fd326c976c498423a1df4801f3ef65c8bc7a8b68a8a87f1bc31" => :el_capitan
    sha256 "5b7526780e9ad562555a03d2d3d66c6aabdc9b0502aad0537b5588ab568fca6f" => :yosemite
    sha256 "d440c657e0cfd21cc6e8b86bed857a731f8cd80fa574a5366a5c70fb6192bbd7" => :mavericks
  end

  head do
    url "https://git.videolan.org/git/libaacs.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

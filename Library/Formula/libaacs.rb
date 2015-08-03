class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.8.1/libaacs-0.8.1.tar.bz2"
  mirror "http://videolan-nyc.defaultroute.com/libaacs/0.8.1/libaacs-0.8.1.tar.bz2"
  sha256 "95c344a02c47c9753c50a5386fdfb8313f9e4e95949a5c523a452f0bcb01bbe8"

  bottle do
    cellar :any
    sha256 "7400d1add43105cc37e0f0901b8ec697e9173289f5551929a63939c16147e11e" => :yosemite
    sha256 "023017918e674900f04616fbd4a312627b632236f7aa290e9b05ba0b03c90288" => :mavericks
    sha256 "294596adf06da1cf609775be4cd03b4abc150208dddb62f6bfb893169dc8ed15" => :mountain_lion
  end

  head do
    url "git://git.videolan.org/libaacs.git"

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

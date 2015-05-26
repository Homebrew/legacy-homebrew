class Libaacs < Formula
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "ftp://ftp.videolan.org/pub/videolan/libaacs/0.8.1/libaacs-0.8.1.tar.bz2"
  mirror "http://videolan-nyc.defaultroute.com/libaacs/0.8.1/libaacs-0.8.1.tar.bz2"
  sha256 "95c344a02c47c9753c50a5386fdfb8313f9e4e95949a5c523a452f0bcb01bbe8"

  bottle do
    cellar :any
    revision 1
    sha1 "4835b5d14f3c078e60a1149648b6788ca49f523b" => :yosemite
    sha1 "9352defc959c0587e4eaaab4f93e777139cdc964" => :mavericks
    sha1 "69c286aeceb83e3e602872e03bc9eef3882c6631" => :mountain_lion
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
    system "make install"
  end
end

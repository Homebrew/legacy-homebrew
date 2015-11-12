class Kytea < Formula
  desc "Toolkit for analyzing text, especially Japanese and Chinese"
  homepage "http://www.phontron.com/kytea/"
  url "http://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz"
  sha256 "534a33d40c4dc5421f053c71a75695c377df737169f965573175df5d2cff9f46"

  bottle do
    sha1 "7a04bfa95710808c1f0f26e9c384d10705ca367d" => :yosemite
    sha1 "b1631db9325f7f52c54edbff0712a7b513047c9e" => :mavericks
    sha1 "5d0b41f2112c6c06ec088c2fc2e32dd8c60a6790" => :mountain_lion
  end

  head do
    url "https://github.com/neubig/kytea.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

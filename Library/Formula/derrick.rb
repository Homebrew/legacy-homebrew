class Derrick < Formula
  desc "A Simple Network Stream Recorder"
  homepage "https://github.com/rieck/derrick"
  url "https://github.com/rieck/derrick/archive/0.3.tar.gz"
  sha256 "3f67a1203866eb58922c00864b83fd353cdc4d0b55aedf065b075d87180e40fb"

  depends_on "libnids"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  head do
    url "https://github.com/rieck/derrick.git"
  end

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/derrick", "-V"
  end
end

require "formula"

class Mmseg < Formula
  homepage "http://www.coreseek.cn/opensource/mmseg//"
  url "https://github.com/RobinQu/mmseg/archive/3.2.15.tar.gz"
  sha1 "bf58446b10becee25512575664db060455d592a4"

  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build

  def install
    ENV.deparallelize
    system "aclocal"
    system "glibtoolize", "--copy", "--force", "--ltdl"
    system "autoreconf", "-i", "-f"
    system "automake", "--a"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"text").write("天气真好")
    `mmseg -d #{HOMEBREW_PREFIX}/etc #{testpath}/text`
  end
end

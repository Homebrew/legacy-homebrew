class Liboping < Formula
  desc "C library to generate ICMP echo requests"
  homepage "http://noping.cc"
  url "http://noping.cc/files/liboping-1.8.0.tar.bz2"
  sha256 "1dcb9182c981b31d67522ae24e925563bed57cf950dc681580c4b0abb6a65bdb"

  bottle do
    sha1 "227e7e74330510ac76e8442c685b8a6a5edea9cb" => :yosemite
    sha1 "77cfac843cbcff2f2c0d8040e76b2abe321c9a64" => :mavericks
    sha1 "1bf78b5ae02d6ec9c7436da117f3f33e7cb61bee" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    "Run oping and noping sudo'ed in order to avoid the 'Operation not permitted'"
  end
end

class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2"
  sha256 "bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "31ee8604a8a59c9257c221639361eb943a75946b373d6e9ebf03d94671eb53b1" => :el_capitan
    sha256 "89c6a74cb5e584aada110adaaa68d24738f463100541578268b1c44bc2f70bb0" => :yosemite
    sha256 "1cc3a9e1da7b5a35ea9e4592f6ccbc1371b48c7fca40fe242dfabb1b1ef98e34" => :mavericks
  end

  head do
    url "https://github.com/itstool/itstool.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libxml2" => "with-python"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2"
  sha256 "bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a"

  bottle do
    cellar :any
    sha256 "3d9f3da33955d74521a2aee1ce75332868e2244f4293fe30c9d1f649a2e036e6" => :yosemite
    sha256 "1c4826404a602f0931e5367b1fb5258d9a37986301170b099fa55f744bd31b9c" => :mavericks
    sha256 "fd069b0b6f5c20fc420b4d21e5c025c2df934de9454c2d1fec85a0d11224783f" => :mountain_lion
  end

  head do
    url "https://github.com/itstool/itstool.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :python
  depends_on "libxml2" => "with-python"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

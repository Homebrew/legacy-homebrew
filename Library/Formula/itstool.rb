class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2"
  sha256 "bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a"

  bottle do
    cellar :any
    sha1 "25b55065039462db7fe3fb238b97af2a4a83b755" => :yosemite
    sha1 "0ce0a174f26de66fb8ecc6e344c2df02dc699d63" => :mavericks
    sha1 "2a9c5f6e0b35202c3520855c04497bc092c47ab1" => :mountain_lion
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

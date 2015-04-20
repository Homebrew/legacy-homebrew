class Gistit < Formula
  homepage "http://gistit.herokuapp.com/"
  url "https://github.com/jrbasso/gistit/archive/v0.1.3.tar.gz"
  sha1 "62b9797a656b15da9196b6c9ee355c0c81bdc3ac"

  bottle do
    cellar :any
    sha1 "ef2f453dfcd08d831396992392f377fe8fba96bf" => :yosemite
    sha1 "20bb22672bfc53b1f51e469846eeece2babdbd65" => :mavericks
    sha1 "b0be23b824c1ea269c0812a6a8ddaecd6917c549" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jansson"

  def install
    mv "configure.in", "configure.ac" # silence warning
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gistit", "-v"
  end
end

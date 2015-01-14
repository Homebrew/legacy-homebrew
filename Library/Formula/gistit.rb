class Gistit < Formula
  homepage "http://gistit.herokuapp.com/"
  url "https://github.com/jrbasso/gistit/archive/v0.1.3.tar.gz"
  sha1 "62b9797a656b15da9196b6c9ee355c0c81bdc3ac"

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

require 'formula'

class Gistit < Formula
  homepage 'http://gistit.herokuapp.com/'
  url 'https://github.com/jrbasso/gistit/archive/v0.1.2.tar.gz'
  sha1 '9b20f3c0f81a9cb07e904e4f98f727e07caab8f3'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jansson"

  def install
    mv "configure.in", "configure.ac" # silence warning
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/gistit", "-v"
  end
end

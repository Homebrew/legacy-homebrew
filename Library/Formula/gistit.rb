require 'formula'

class Gistit < Formula
  homepage 'http://gistit.herokuapp.com/'
  url 'https://github.com/jrbasso/gistit/archive/v0.1.1.tar.gz'
  sha1 '882269ea6f88f46d9ca0a136fa96124c5cc8cd82'

  depends_on :autoconf
  depends_on :automake
  depends_on 'jansson'

  def install
    mv "configure.in", "configure.ac" # silence warning
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/gistit -v"
  end
end

require 'formula'

class Hamlib < Formula
  homepage 'http://hamlib.sourceforge.net'
  url 'http://pkgs.fedoraproject.org/repo/pkgs/hamlib/hamlib-1.2.15.3.tar.gz/3cad8987e995a00e5e9d360e2be0eb43/hamlib-1.2.15.3.tar.gz'
  sha1 '15ab404ea37e5627abea89f9e051d393966918ba'

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/rigctl -V"
  end
end

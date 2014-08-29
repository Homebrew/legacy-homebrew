require 'formula'

class Hamlib < Formula
  homepage 'http://hamlib.sourceforge.net'
  url 'http://pkgs.fedoraproject.org/repo/pkgs/hamlib/hamlib-1.2.15.3.tar.gz/3cad8987e995a00e5e9d360e2be0eb43/hamlib-1.2.15.3.tar.gz'
  sha1 '15ab404ea37e5627abea89f9e051d393966918ba'

  bottle do
    sha1 "3b8a435d8f65ac2188eb6adc875c939ac9451eb5" => :mavericks
    sha1 "fcd7912952665e7e6e7c8ae7de37dbe2c66d21f3" => :mountain_lion
    sha1 "5653222a95a51001c0ca9eff84e7f0443628b8f8" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on :libltdl
  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end

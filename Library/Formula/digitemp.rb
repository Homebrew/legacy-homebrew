class Digitemp < Formula
  desc "Read temperature sensors in a 1-Wire net"
  homepage "https://www.digitemp.com/"
  url "https://github.com/bcl/digitemp/archive/v3.7.1.tar.gz"
  sha256 "6fa4d965350d5501b6ca73ee8a09276ca4f65b6d85dae62f0a796239bae5000e"
  head "https://github.com/bcl/digitemp.git"

  bottle do
    cellar :any
    sha256 "b29a65bbf11f11ff637ce398461cd84750b5f66dabef902878af443033c751fa" => :el_capitan
    sha256 "7b1e87bb23751f09debbe4f2062f2329a8fd7451d01e872a84983709ca4fe351" => :yosemite
    sha256 "4559a48e8b4b438cd9bbc27efd78a7fe9e5555ed24cc9ee979a3fbdde1381107" => :mavericks
  end

  depends_on "libusb-compat"

  def install
    mkdir_p "build-serial/src"
    mkdir_p "build-serial/userial/ds9097"
    mkdir_p "build-serial/userial/ds9097u"
    mkdir_p "build-usb/src"
    mkdir_p "build-usb/userial/ds2490"
    system "make", "-C", "build-serial", "-f", "../Makefile", "SRCDIR=..", "ds9097", "ds9097u"
    system "make", "-C", "build-usb", "-f", "../Makefile", "SRCDIR=..", "ds2490"
    bin.install "build-serial/digitemp_DS9097"
    bin.install "build-serial/digitemp_DS9097U"
    bin.install "build-usb/digitemp_DS2490"
    man1.install "digitemp.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS9097.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS9097U.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS2490.1"
  end

  # digitemp has no self-tests and does nothing without a 1-wire device,
  # so at least check the individual binaries compiled to what we expect.
  test do
    assert_match "Compiled for DS2490", shell_output("#{bin}/digitemp_DS2490 2>&1", 255)
    assert_match "Compiled for DS9097", shell_output("#{bin}/digitemp_DS9097 2>&1", 255)
    assert_match "Compiled for DS9097U", shell_output("#{bin}/digitemp_DS9097U 2>&1", 255)
  end
end

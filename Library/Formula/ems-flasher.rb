class EmsFlasher < Formula
  desc "Software for flashing the EMS Gameboy USB cart"
  homepage "https://lacklustre.net/projects/ems-flasher/"
  url "https://lacklustre.net/projects/ems-flasher/ems-flasher-0.03.tgz"
  sha256 "d77723a3956e00a9b8af9a3545ed2c55cd2653d65137e91b38523f7805316786"
  head "git://lacklustre.net/ems-flasher"

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "ems-flasher"
  end

  test do
    system "#{bin}/ems-flasher", "--version"
  end
end

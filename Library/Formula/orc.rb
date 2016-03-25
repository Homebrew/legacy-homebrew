class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.25.tar.xz"
  sha256 "c1b1d54a58f26d483f0b3881538984789fe5d5460ab8fab74a1cacbd3d1c53d1"

  bottle do
    cellar :any
    sha256 "74f9286ad20ccad5fcb2f855bd2d855b6709fa5a2f804928c710d3e3229d8087" => :el_capitan
    sha256 "fa8e5bd4d5899fd420a772025005ec8b25e3f446c01ec61a357d4edc64734aba" => :yosemite
    sha256 "6f998c310042780d4a8deccd9e3aae25362b7904932d45e4944d761f77bf1fe1" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make", "install"
  end

  test do
    system "#{bin}/orcc", "--version"
  end
end

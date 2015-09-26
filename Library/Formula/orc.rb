class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "http://cgit.freedesktop.org/gstreamer/orc/"
  url "http://gstreamer.freedesktop.org/src/orc/orc-0.4.23.tar.xz"
  sha256 "767eaebce2941737b43368225ec54598b3055ca78b4dc50c4092f5fcdc0bdfe7"

  bottle do
    cellar :any
    sha256 "078d71f30efc017e40b795de1b8c5e8f6d75a1d5cc6ab0532cc3fadd2a82fde4" => :el_capitan
    sha1 "e85053dcb4751277a06e4e3b72a4e63a74bdb907" => :yosemite
    sha1 "4997cd243a86e7eb26c6d63e1cf3901da5281729" => :mavericks
    sha1 "b509729d8f6f27062c0f5e2f9a54cec143b8d98c" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make", "install"
  end
end

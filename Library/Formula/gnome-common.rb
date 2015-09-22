class GnomeCommon < Formula
  desc "Core files for GNOME"
  homepage "https://git.gnome.org/browse/gnome-common/"
  url "https://download.gnome.org/sources/gnome-common/3.18/gnome-common-3.18.0.tar.xz"
  sha256 "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

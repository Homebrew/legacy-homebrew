class GnomeCommon < Formula
  desc "Core files for GNOME"
  homepage "https://git.gnome.org/browse/gnome-common/"
  url "https://download.gnome.org/sources/gnome-common/3.18/gnome-common-3.18.0.tar.xz"
  sha256 "22569e370ae755e04527b76328befc4c73b62bfd4a572499fde116b8318af8cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5ad22711bdc05e9dbe4c4891ad06f146bc81b4d0d7d737d582f32e36f4e6fc7" => :el_capitan
    sha256 "7e3512e3a7c39f759ab9f3642831961b355f3f83ae6e19a26fdaf91739870e23" => :yosemite
    sha256 "a96e5dedc2888b6caa326da0abd8eb7d3f1426407e8bef82a6ba0f41adb7016a" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

class MmCommon < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "http://www.gtkmm.org"
  url "https://download.gnome.org/sources/mm-common/0.9/mm-common-0.9.10.tar.xz"
  sha256 "16c0e2bc196b67fbc145edaecb5dbe5818386504fe5703de27002d77140fa217"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f34165d9e854d0d3cf261775c53191115537c343d65771a458ed827357f05a2" => :el_capitan
    sha256 "8b131b53a8ace806b0b6a3c75be145312377b0f25d92ea578ba07e27809fa852" => :yosemite
    sha256 "d04a14c639c497aea15e39ab5c70fb6753d3a7983528cb8b18a7e309babedbde" => :mavericks
  end

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end

class MmCommon < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "http://www.gtkmm.org"
  url "https://download.gnome.org/sources/mm-common/0.9/mm-common-0.9.10.tar.xz"
  sha256 "16c0e2bc196b67fbc145edaecb5dbe5818386504fe5703de27002d77140fa217"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2930e83c4fcfbb96e3c377f82839b3b8e6b07987b4febfaaac7345e1d031361" => :el_capitan
    sha256 "d16a5244363b156877d47c4b1cdc4d95727d2713ca73ab42ff56552cfd6f293b" => :yosemite
    sha256 "76fb9a4e73abdd1be67f13ea5685acaf91ed8218045fd29dfa069639f991c9d9" => :mavericks
  end

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end

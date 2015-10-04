class IsoCodes < Formula
  desc "ISO language, territory, currency, script codes, and their translations"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.61.tar.xz"
  sha256 "a79bf119afdc20feef12965f26f9d97868819003a76355a6f027a14a6539167d"

  head "git://git.debian.org/git/iso-codes/iso-codes.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "443f678c1dec1caf6324f51fbe14aba98504b34d1207de8a86c75f4aceb00d22" => :el_capitan
    sha256 "de96d8f33f363621e11c881f8f013a68bffbd58e0d0e9371eaa8f6f00c5b6c5f" => :yosemite
    sha256 "d5a5beccd811923c51c655d9f3e9f3b1279340e4f67da87b8d0f334222e236a9" => :mavericks
    sha256 "f0a590da2b2f1e86683b17ebc5cd419fe06110b90160adbcce3a551e0136a26e" => :mountain_lion
  end

  depends_on "gettext" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

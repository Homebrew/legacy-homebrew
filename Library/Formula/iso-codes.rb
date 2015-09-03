class IsoCodes < Formula
  desc "ISO language, territory, currency, script codes, and their translations"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.61.tar.xz"
  sha256 "a79bf119afdc20feef12965f26f9d97868819003a76355a6f027a14a6539167d"

  head "git://git.debian.org/git/iso-codes/iso-codes.git", :shallow => false

  bottle do
    cellar :any
    sha256 "0f9b751320df718306bab937dea5b3289eccdf7f166ddd73a7d1e05810e0cbd5" => :yosemite
    sha256 "83ecd6c02b005a87ceb02bc780a942e8d6309ee487e998b4598e21d25ed65bc8" => :mavericks
    sha256 "e528769ebea62fa694eb6a7ab1761becf6e21010bb646e71bac0dabd8123e7fd" => :mountain_lion
  end

  depends_on "gettext" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

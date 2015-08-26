class IsoCodes < Formula
  desc "ISO language, territory, currency, script codes, and their translations"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.59.tar.xz"
  sha256 "63d5ef035a96223f1fc8f36b711082f806e1666852dfc4149eeca8fd435d76ed"

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

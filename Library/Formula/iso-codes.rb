class IsoCodes < Formula
  desc "ISO language, territory, currency, script codes, and their translations"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.64.tar.xz"
  sha256 "5ef061381e37e9576760df1ad504d4bbc84c270da30512b2891baed9add70729"

  head "git://git.debian.org/git/iso-codes/iso-codes.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "7177a7df2eb13cfe6ad956f74d5a78487c333d5050df90e448f80076ad127fef" => :el_capitan
    sha256 "5ab4d61eba9916d086575b037dd770e901ea7cb0504c4c419a26da0989f16e3a" => :yosemite
    sha256 "41f7a434bbb88786c6c9274a2741ab40602a7e2ef9bf3a3d5884871b054bb2c0" => :mavericks
  end

  depends_on "gettext" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

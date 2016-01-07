class IsoCodes < Formula
  desc "ISO language, territory, currency, script codes, and their translations"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.64.tar.xz"
  sha256 "5ef061381e37e9576760df1ad504d4bbc84c270da30512b2891baed9add70729"

  head "git://git.debian.org/git/iso-codes/iso-codes.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "355fcd7d9f70238d58f29410783d8784f41d2576cc06e3ab3ba2be3abc37ed76" => :el_capitan
    sha256 "7d35d749b7ec99d9437778f012f3add07085405faa888c7861fa39c5cd0725e1" => :yosemite
    sha256 "f2c49b4911463b54b1a0d527064fc4628f98eab13dd03f6938fa5b2ad763eab9" => :mavericks
  end

  depends_on "gettext" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

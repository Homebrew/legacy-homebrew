class Libiptcdata < Formula
  desc "Virtual package provided by libiptcdata0"
  homepage "http://libiptcdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libiptcdata/libiptcdata/1.0.4/libiptcdata-1.0.4.tar.gz"
  sha256 "79f63b8ce71ee45cefd34efbb66e39a22101443f4060809b8fc29c5eebdcee0e"

  bottle do
    revision 1
    sha1 "bae5cce39a9a013a532265d911295085afc909f4" => :yosemite
    sha1 "cc888c096c24e6215292dabaeaa25378429e8232" => :mavericks
    sha1 "8794ce897c84182173496a3aed8577be0f2ec609" => :mountain_lion
  end

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

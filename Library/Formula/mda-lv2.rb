class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2/"
  url "https://download.drobilla.net/mda-lv2-1.2.2.tar.bz2"
  sha256 "a476c31ed9f8b009ebacc32a02d06ba9584c0d0d03f03dd62b1354d10a030442"

  bottle do
    cellar :any
    revision 1
    sha256 "8177c7c9d23fc7daf59c764a36d336f2d7dd3d7617752c33f132ed34a08f37f0" => :el_capitan
    sha256 "670da0efa727514c30897830e6dc38eef62b29e7f7c540f37821bc3997ecf64d" => :yosemite
    sha256 "20fafd017914d54441227646c528b951c16adfe5b9ed4522b8d8cf074cc25acd" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end

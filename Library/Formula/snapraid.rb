class Snapraid < Formula
  homepage "http://snapraid.sourceforge.net/"
  head "git://snapraid.git.sourceforge.net/gitroot/snapraid/snapraid"
  url "https://downloads.sourceforge.net/project/snapraid/snapraid-7.1.tar.gz"
  sha1 "3aa3ee982c21c6e19f31988cc1805dc535404334"

  bottle do
    cellar :any
    sha256 "5725dceb381a57c2e216cf13f51c0eb68793d772bedaa211ac4de163c23d6a1d" => :yosemite
    sha256 "0fe2f7a73f36103c67b7308f7267be8a37277ed03f8b1573906102c0cf6ed510" => :mavericks
    sha256 "ad68ec9b63b3bc6cc46c2905a57d3b23a5154a94fdf86cfa12a58742c7ec12e3" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

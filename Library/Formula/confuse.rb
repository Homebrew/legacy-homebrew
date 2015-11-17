class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "http://www.nongnu.org/confuse/"
  url "http://download.savannah.nongnu.org/releases/confuse/confuse-2.7.tar.gz"
  sha256 "e32574fd837e950778dac7ade40787dd2259ef8e28acd6ede6847ca895c88778"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "0df403420102e0215a8c2c98d091c1dc8f88d4b384a29cb9b4933c4a24448a31" => :el_capitan
    sha256 "2d474d4e4e735c0b359424164f6458e07101b6ce051bd018b88e2bfb1f8571d1" => :yosemite
    sha256 "d365907b21e36075ce3980b8ab8f5131da731f6f992869b41227be34256f15b1" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

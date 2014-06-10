require "formula"

class Zile < Formula
  homepage "https://www.gnu.org/software/zile/"
  url "http://ftpmirror.gnu.org/zile/zile-2.4.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/zile/zile-2.4.11.tar.gz"
  sha1 "ad2efb80031c3a406f8f83ac5d400a38bc297434"

  bottle do
    sha1 "6112330f840500f201c9903a67003f22c484e458" => :mavericks
    sha1 "0daeecd50c14a9338527fcfc367f96487d538cd4" => :mountain_lion
    sha1 "1a32cf3d3c235bba1fd570e7bff81190851ec411" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build
  depends_on "bdw-gc"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

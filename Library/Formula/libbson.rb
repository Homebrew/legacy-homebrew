require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.1.0/libbson-1.1.0.tar.gz"
  sha1 "5f9b9449d795637601e7e8a2e0abd747a75c1f37"

  bottle do
    cellar :any
    sha1 "290424b019dfc4ddf6aa0eb441b7882d3d60d688" => :yosemite
    sha1 "ce84cf5b8745f559d0c9275c45ae0212d0b39e96" => :mavericks
    sha1 "12916e6c197294cfafd5de0eab2d25eb732d4a30" => :mountain_lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end

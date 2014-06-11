require "formula"

class Jpegoptim < Formula
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.1.tar.gz"
  sha1 "07561b8a06806c4a2172a62e3f5e45b961353b2d"
  head "https://github.com/tjko/jpegoptim.git"

  bottle do
    cellar :any
    sha1 "dca2904e50276aa6ef58dbd0ee6abb909c2c179d" => :mavericks
    sha1 "90e9948dc8dbed0d143315c38e83c57c225cefb3" => :mountain_lion
    sha1 "9907f652fb2e72447ddbb192bd83988e382d8271" => :lion
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make install"
  end
end

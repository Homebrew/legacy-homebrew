class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/archive/v5.9.6.tar.gz"
  sha256 "b06ff3a220edf4ea9270c4346c3cf9727b3177bf9ae7feddfa8ad5efdad5c0c0"

  bottle do
    cellar :any
    sha1 "12f394ce6f8694efa03d1a7ce2d18fc9a069a75c" => :yosemite
    sha1 "5243422d56451c96768528739932c5651e7a10d7" => :mavericks
    sha1 "62ca1e24ca20cecb83b8cbeeaf1335b94faffe4b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

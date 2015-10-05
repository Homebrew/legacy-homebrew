class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "http://libopenraw.freedesktop.org/download/exempi-2.2.2.tar.bz2"
  sha256 "0e7ad0e5e61b6828e38d31a8cc59c26c9adeed7edf4b26708c400beb6a686c07"

  bottle do
    cellar :any
    sha256 "ff222f7f34a2bc37821c065e29649bf68eafe9b712fdd29adcf6cae24f07fbdb" => :mavericks
    sha256 "9f961eca99f75577c67afd2c895ade28648ce02728ea6815f41af809a570a029" => :mountain_lion
    sha256 "82b4f0a08408ce7ab52bb1e7d784522639d9d9341d1ea7c587864e45865d763f" => :lion
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end

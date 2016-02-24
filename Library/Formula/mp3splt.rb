class Mp3splt < Formula
  desc "Command-line interface to split MP3 and Ogg Vorbis files"
  homepage "http://mp3splt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mp3splt/mp3splt/2.6.2/mp3splt-2.6.2.tar.gz"
  sha256 "3ec32b10ddd8bb11af987b8cd1c76382c48d265d0ffda53041d9aceb1f103baa"

  bottle do
    sha256 "d30a89754b5e57a5fd0fff9f794e14ddd920d8f1169158d166e8cd427f85dcd1" => :yosemite
    sha256 "d928c6cc582737877a1e6a1e074f1d9577595eac6ac4a0b52f533141f0e2c4af" => :mavericks
    sha256 "acc0022ebbe437c18d4f3dfca1805a459081288f437101e1cd329a31ca81e522" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libmp3splt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3splt", "-t", "0.1", test_fixtures("test.mp3")
  end
end

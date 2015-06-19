require "formula"

class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "http://mikmod.raphnet.net/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.6/mikmod-3.2.6.tar.gz"
  sha1 "55677382ab3e6d5ed35c520669e2cedd395a8ebb"

  bottle do
    sha1 "81085407e9a27cf49e46cee5ec0d7b6c613cccc1" => :mavericks
    sha1 "c16208a4e40528c2ef2d70d404b80432bc37f2e2" => :mountain_lion
    sha1 "fcb7a780fc126c97fdd5c8004785249c6ad5375a" => :lion
  end

  depends_on "libmikmod"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  test do
    system "#{bin}/mikmod", "-V"
  end
end

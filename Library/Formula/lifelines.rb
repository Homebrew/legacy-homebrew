class Lifelines < Formula
  desc "Text-based genealogy software"
  homepage "http://lifelines.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lifelines/lifelines/3.0.62/lifelines-3.0.62.tar.gz"
  sha256 "2f00441ac0ed64aab8f76834c055e2b95600ed4c6f5845b9f6e5284ac58a9a52"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

class Lbzip2 < Formula
  desc "Parallel bzip2 utility"
  homepage "https://github.com/kjn/lbzip2"
  url "https://github.com/downloads/kjn/lbzip2/lbzip2-2.2.tar.gz"
  sha256 "b905f763a5859670e36b15d016fb6bb73d6718905fc0e2a9fa1dbc11f30b0d80"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    touch "fish"
    system "#{bin}/lbzip2", "fish"
    system "#{bin}/lbunzip2", "fish.bz2"
  end
end

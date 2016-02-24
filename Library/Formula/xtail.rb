class Xtail < Formula
  desc "Watch growth of multiple files or directories (like `tail -f`)"
  homepage "https://www.unicom.com/sw/xtail"
  url "https://www.unicom.com/files/xtail-2.1.tar.gz"
  sha256 "75184926dffd89e9405769b24f01c8ed3b25d3c4a8eac60271fc5bb11f6c2d53"

  bottle do
    cellar :any_skip_relocation
    sha256 "a579041c4d693dd444464228dcd0175e79f31708b62ad3ccf55a8f545ce67ed7" => :el_capitan
    sha256 "60a2bcabfb83e8ab4df95b2417ccf5c49c5ca242853ff16e2a106f3e37f6005e" => :yosemite
    sha256 "939117402a33f5037aa7e49f5228e0d0b852e0e39e85d81357b8955864bd26eb" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    man1.mkpath
    bin.mkpath
    system "make", "install"
  end

  test do
    system "#{bin}/xtail"
  end
end

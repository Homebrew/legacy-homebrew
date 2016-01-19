class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "http://www.chiark.greenend.org.uk/~ian/adns/"
  url "http://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.5.0.tar.gz"
  sha256 "7fc5eb4d315111a3a3a3f45ff143339ad4050185fbe6bff687f21364cb4ae841"
  head "git://git.chiark.greenend.org.uk/~ianmdlvl/adns.git"

  bottle do
    cellar :any
    sha256 "164485aab044141ce1a0234be59024888ce4ffcaff3a6fee610e1ff46ab7a43d" => :yosemite
    sha256 "a7340ab0e7f90f369e7e6feb470475e551c38d0d257c49ee090bc5fc19b93861" => :mavericks
    sha256 "e3ff55e6fc0d0297a2e96ea0f4004fbb05330d0ce3a8932073f020a26f79961d" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/adnsheloex", "--version"
  end
end

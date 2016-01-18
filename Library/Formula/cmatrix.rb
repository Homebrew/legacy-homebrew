class Cmatrix < Formula
  desc "Console Matrix"
  homepage "http://www.asty.org/cmatrix/"
  url "http://www.asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cmatrix/cmatrix_1.2a.orig.tar.gz"
  sha256 "1fa6e6caea254b6fe70a492efddc1b40ad7ccb950a5adfd80df75b640577064c"

  bottle do
    cellar :any_skip_relocation
    sha256 "da919a1964d6ef0633eac14bd7138ab91f6676d4dfc36fd5e27f956943714d22" => :el_capitan
    sha256 "14ae5c06eac81783ee61e3547d9de174f6742c688a254e172d7c2e566f14b426" => :yosemite
    sha256 "8479d25ddc608462c974bbc1a9fb229f6ffa99d19368fcd43f667bc6a6d8493f" => :mavericks
    sha256 "49e2833e6d6967528475c3124f4b2927b7169030704d63811b34d20a01ea79e3" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/cmatrix", "-V"
  end
end

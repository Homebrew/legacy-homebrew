class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "http://mikmod.raphnet.net/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.6/mikmod-3.2.6.tar.gz"
  sha256 "04544e0edb36a19fab61233dff97430969cff378a98f5989a1378320550e2673"

  bottle do
    sha256 "759d6d16ac5743599942b67695b3aca27996f40b96e61210905f0bfdfc4c48a7" => :mavericks
    sha256 "377735f1553d44e6f02a6dc92742a0c0c84546a7085c3a1839488ae26a9f280a" => :mountain_lion
    sha256 "ab3e1ab1d55c3f2197db079a0f05570ac95602ebbde179ca43be83b65d51a3aa" => :lion
  end

  depends_on "libmikmod"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/mikmod", "-V"
  end
end

class Xstow < Formula
  desc "Extended replacement for GNU Stow"
  homepage "http://xstow.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xstow/xstow-1.0.2.tar.bz2"
  sha256 "6f041f19a5d71667f6a9436d56f5a50646b6b8c055ef5ae0813dcecb35a3c6ef"

  fails_with :clang do
    cause <<-EOS.undent
      clang does not support unqualified lookups in c++ templates, see:
      http://clang.llvm.org/compatibility.html#dep_lookup
      EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-static", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xstow", "-Version"
  end
end

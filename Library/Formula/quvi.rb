class Quvi < Formula
  desc "Parse video download URLs"
  homepage "http://quvi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quvi/0.4/quvi/quvi-0.4.2.tar.bz2"
  sha256 "1f4e40c14373cb3d358ae1b14a427625774fd09a366b6da0c97d94cb1ff733c3"

  depends_on "pkg-config" => :build
  depends_on "libquvi"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/quvi", "--version"
  end
end

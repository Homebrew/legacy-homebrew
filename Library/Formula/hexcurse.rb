class Hexcurse < Formula
  desc "Ncurses-based console hex editor"
  homepage "https://github.com/LonnyGomes/hexcurse"
  url "https://github.com/LonnyGomes/hexcurse/archive/v1.60.0.tar.gz"
  sha256 "f6919e4a824ee354f003f0c42e4c4cef98a93aa7e3aa449caedd13f9a2db5530"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/hexcurse", "-help"
  end
end

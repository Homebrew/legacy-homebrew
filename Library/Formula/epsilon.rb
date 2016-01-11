class Epsilon < Formula
  desc "Powerful wavelet image compressor"
  homepage "http://epsilon-project.sourceforge.net"
  url "https://downloads.sourceforge.net/project/epsilon-project/epsilon/0.9.2/epsilon-0.9.2.tar.gz"
  sha256 "5421a15969d4d7af0ac0a11d519ba8d1d2147dc28d8c062bf0c52f3a0d4c54c4"

  depends_on "popt"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

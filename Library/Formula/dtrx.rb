class Dtrx < Formula
  desc "Intelligent archive extraction"
  homepage "http://brettcsmith.org/2007/dtrx/"
  url "http://brettcsmith.org/2007/dtrx/dtrx-7.1.tar.gz"
  sha256 "1c9afe48e9d9d4a1caa4c9b0c50593c6fe427942716ce717d81bae7f8425ce97"

  depends_on "cabextract" => :optional
  depends_on "lha" => :optional
  depends_on "unshield" => :optional
  depends_on "unrar" => :recommended
  depends_on "p7zip" => :recommended

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/dtrx", "--version"
  end
end

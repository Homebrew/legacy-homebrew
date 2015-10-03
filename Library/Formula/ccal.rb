class Ccal < Formula
  url "http://ccal.chinesebay.com/ccal/ccal-2.5.3.tar.gz"
  desc "Create Chinese calendars for print or browsing"
  homepage "http://ccal.chinesebay.com/ccal"
  sha256 "3d4cbdc9f905ce02ab484041fbbf7f0b7a319ae6a350c6c16d636e1a5a50df96"

  def install
    system "make", "-e", "BINDIR=#{bin}", "install"
    system "make", "-e", "MANDIR=#{man}", "install-man"
  end

  test do
    output = shell_output("#{bin}/ccal 2 2014")
    assert output.include?("Year JiaWu, Month 1X")
  end
end

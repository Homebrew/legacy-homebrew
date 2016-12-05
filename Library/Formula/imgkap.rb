class Imgkap < Formula
  desc "Tool to create nautical charts in KAP format."
  homepage "https://github.com/nohal/imgkap"
  url "https://github.com/nohal/imgkap/archive/v1.13.tar.gz"
  sha256 "54f01060057c85467a1f198abc397a9dbc96107c8d0084e94b29552bdda44fb6"

  depends_on "freeimage"

  def install
    system "make", "imgkap"
    bin.install "imgkap"
    pkgshare.install "examples"
  end

  test do
    system "#{bin}/imgkap", "#{pkgshare}/examples/PWAE10.gif", 45, -95, "139;250", 25, -45, "1532;938", "natl.kap"
    assert File.exist?("natl.kap")
  end
end

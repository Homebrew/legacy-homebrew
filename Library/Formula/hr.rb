class Hr < Formula
  desc "<hr />, for your terminal window"
  homepage "https://github.com/LuRsT/hr"
  url "https://github.com/LuRsT/hr/archive/1.1.tar.gz"
  sha256 "1aa26d670a55da3a97730c89fe5fa6ae690e20d5aa8e56e07802afc75c974442"

  head "https://github.com/LuRsT/hr"

  def install
    bin.install "hr"
    man1.install "hr.1"
  end

  test do
    system "#{bin}/hr", "-#-"
  end
end

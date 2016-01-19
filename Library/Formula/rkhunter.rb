class Rkhunter < Formula
  desc "Rootkit hunter"
  homepage "http://rkhunter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.2/rkhunter-1.4.2.tar.gz"
  sha256 "789cc84a21faf669da81e648eead2e62654cfbe0b2d927119d8b1e55b22b65c3"

  def install
    system "./installer.sh", "--layout", "custom", prefix, "--install"
  end

  test do
    system "#{bin}/rkhunter", "--version"
  end
end

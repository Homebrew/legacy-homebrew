require 'formula'

class Rkhunter < Formula
  homepage 'http://rkhunter.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.0/rkhunter-1.4.0.tar.gz'
  sha1 '48798beec504c00af93bf64b6e35dfc7d7aaff07'

  def install
    system "./installer.sh", "--layout", "custom", prefix, "--install"
  end

  test do
    system "#{bin}/rkhunter", "--version"
  end
end

require 'formula'

class Rkhunter < Formula
  homepage 'http://rkhunter.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/rkhunter/rkhunter/1.4.2/rkhunter-1.4.2.tar.gz'
  sha1 'da01bc6757e14549560ad6ea46d1e93dbf5ac90f'

  def install
    system "./installer.sh", "--layout", "custom", prefix, "--install"
  end

  test do
    system "#{bin}/rkhunter", "--version"
  end
end

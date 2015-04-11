class Shmux < Formula
  homepage "http://web.taranis.org/shmux/"
  url "http://web.taranis.org/shmux/dist/shmux-1.0.2.tgz"
  sha256 "0886aaca4936926d526988d85df403fa1679a60c355f1be8432bb4bc1e36580f"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shmux", "-h"
  end
end

class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://labs.riseup.net/code/projects/backupninja"
  head "git://labs.riseup.net/backupninja.git"
  url "https://labs.riseup.net/code/attachments/download/275/backupninja-1.0.1.tar.gz"
  sha256 "10fa5dbcd569a082b8164cd30276dd04a238c7190d836bcba006ea3d1235e525"

  depends_on "dialog"
  depends_on "gawk"

  skip_clean "etc/backup.d"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

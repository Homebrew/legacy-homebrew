class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "http://tkdiff.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/4.2/tkdiff-4.2.tar.gz"
  sha256 "734bb417184c10072eb64e8d274245338e41b7fdeff661b5ef30e89f3e3aa357"

  def install
    bin.install "tkdiff"
  end

  test do
    system "#{bin}/tkdiff", "--help"
  end
end

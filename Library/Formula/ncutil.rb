class Ncutil < Formula
  desc "Modify OS X's Notification Center from the command-line"
  homepage "https://github.com/jacobsalmela/NCutil"
  url "https://github.com/jacobsalmela/NCutil/archive/2.4.tar.gz"
  version "2.4"
  sha256 "ebea1fe1163e401dd4e7833416001dbf9d60614237700755b55b46d0abf423bc"

  def install
    bin.install "NCutil.py" => "ncutil"
  end

  test do
    system "#{bin}/ncutil", "--help"
  end
end

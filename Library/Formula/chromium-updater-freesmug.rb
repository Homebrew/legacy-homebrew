class ChromiumUpdaterFreesmug < Formula
  desc "Updates FreeSmug Chromium to the latest Version "
  homepage "https://github.com/3vincent/chromium-updater-FreeSMUG"
  url "https://github.com/3vincent/chromium-updater-FreeSMUG/archive/0.1.1.tar.gz"
  sha256 "b26b27d708ae50d141cdd9ad568c56917719653d60311b249926489fb7c8b7d9"

  def install
    bin.install "chromium-updater"
  end
end

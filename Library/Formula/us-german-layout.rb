require "formula"

class UsGermanLayout < Formula
  homepage "http://hci.rwth-aachen.de/USGermanKeyboard"
  url "http://hci.rwth-aachen.de/tiki-download_wiki_attachment.php?attId=793"
  version "0.98"
  sha1 "949c856dee7ef0268457c412bc66a1f48f86b261"

  def install
    bundle_path = "USGerman Keyboard Layout 0.98/Roman.bundle/Contents/Resources"
    layout_path = File.expand_path("~/Library/Keyboard\ Layouts")
    # installing in prefix and making a symlink does not work, OSX requires keyboard layouts to be regular files
    # prefix.install "#{bundle_path}/USGerman.icns"
    # prefix.install "#{bundle_path}/USGerman.keylayout"
    # system "ln", "-s", "#{bundle_path}/USGerman.icns", layout_path
    # system "ln", "-s", "#{bundle_path}/USGerman.keylayout", layout_path

    system "cp", "#{bundle_path}/USGerman.icns", "#{bundle_path}/USGerman.keylayout", layout_path
  end

  test do
    system "ls", "#{File.expand_path("~/Library/Keyboard\ Layouts")}/USGerman.keylayout"
  end

  def caveats
    <<-EOS.undent
    You may find the layout in the Keyboard Preferences - Input Sources - Others - U.S..

    For uninstalling please remove ~/Library/Keyboard\ Layouts/USGerman.*
    EOS
  end
end

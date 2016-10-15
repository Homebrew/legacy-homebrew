require "formula"

class Filebot < Formula
  homepage "http://www.filebot.net/"
  url "https://downloads.sourceforge.net/project/filebot/filebot/HEAD/FileBot_4.1.1/FileBot_4.1.app.tar.gz"
  sha1 "7a4e80f3d2bdb82afaa00e8350eba0c8888b8fe8"
  version "4.1.1"

  def install
    # Create .app bundle in prefix
    (prefix/'FileBot.app').install Dir['*']

    # Create filebot symlink in bin
    bin.install_symlink prefix/'FileBot.app/Contents/MacOS/filebot.sh' => 'filebot'
  end

  def caveats
    "FileBot requires Java 8. Run `java -version` to verify."
  end

  def post_install
    # Clearing cache and temporary files
    system "#{bin}/filebot", "-clear-cache"
  end

  test do
    system "#{bin}/filebot", "-version"
  end
end

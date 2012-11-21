require 'formula'

class Platypus < Formula
  homepage 'http://sveinbjorn.org/platypus'
  url 'https://github.com/pmenglund/Platypus/archive/v4.8.1.tar.gz'
  sha256 '5723a8276bb9ed068149b48994da6f9ee581611eebf9228e0d2977e2eb505dbd'

  head 'https://github.com/sveinbjornt/Platypus', :branch => 'master'

  depends_on :xcode

  def install
    system "xcodebuild", "SYMROOT=build",
                         "-project", "Platypus.xcodeproj",
                         "-target", "platypus",
                         "clean", "install"
    man1.install "CommandLineTool/platypus.1"
    bin.install_p "build/UninstalledProducts/platypus_clt", "platypus"
  end

  def test
    system "#{bin}/platypus", "-v"
  end
end

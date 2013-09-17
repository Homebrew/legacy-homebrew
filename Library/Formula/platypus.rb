require 'formula'

class Platypus < Formula
  homepage 'http://sveinbjorn.org/platypus'
  url 'https://github.com/sveinbjornt/Platypus/raw/4.8/Releases/platypus4.8.src.zip'
  sha1 '39d165b9579600cef637b45c70c82307697bb7be'
  head 'https://github.com/sveinbjornt/Platypus', :branch => 'master'

  depends_on :xcode

  def install
    Dir.chdir 'Platypus 4.8 Source' do
      system "xcodebuild", "SYMROOT=build",
                           "-project", "Platypus.xcodeproj",
                           "-target", "platypus",
                           "clean", "install"
      man1.install "CommandLineTool/platypus.1"
      bin.install "/tmp/Platypus.dst/platypus_clt" => "platypus"
    end
  end

  def test
    system "#{bin}/platypus", "-v"
  end

  def caveats
    s = <<-EOS.undent
      This formula only installs the command-line Platypus tool, not the GUI.
      If you want the GUI, download the app from the project's Web page directly.
    EOS
  end
end

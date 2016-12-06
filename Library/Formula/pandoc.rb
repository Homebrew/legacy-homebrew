require 'formula'

class Pandoc < Formula
  homepage 'http://johnmacfarlane.net/pandoc'
  url "https://pandoc.googlecode.com/files/pandoc-1.11.1.dmg"
  sha1 '00fc2bde8a51e6d004e20948ac9b4a6fca466daf'

  def install
    # mount the installer dmg
    mkdir "pandoc"
    system "hdiutil", "attach", "-mountpoint", "pandoc", "pandoc-#{version}.dmg"
    # extract the files to be installed, into the temp directory (plus usr/local)
    system "tar", "-xzf", "pandoc/pandoc-#{version}.pkg/Contents/Archive.pax.gz"

    # detach the installer dmg
    system "hdiutil", "detach", "pandoc"

    # stage the files
    Dir.chdir("usr/local") do
      prefix.install Dir["*"]
    end
  end

end

require 'formula'

class Appsdeck < Formula
  homepage 'https://appsdeck.eu/'

  if MacOS.prefer_64_bit?
    url 'https://raw.github.com/Appsdeck/appsdeck-executables/master/0.2.2/appsdeck_0.2.2_darwin_amd64.zip'
    sha1 'f4a87edc553e989cc986b082c572182919c80e32'
  else
    url 'https://raw.github.com/Appsdeck/appsdeck-executables/master/0.2.2/appsdeck_0.2.2_darwin_386.zip'
    sha1 '555f80c5ab6b1ed34b4d909eedf1265e956b7f4e'
  end

  version '0.2.2'

  def install
    system "mkdir #{prefix}/bin"
    system "cp appsdeck #{prefix}/bin/"
  end

  test do
    system "#{bin}/appsdeck --version"
  end
end

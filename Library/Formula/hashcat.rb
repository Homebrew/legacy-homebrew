require 'formula'

class Hashcat < Formula
  homepage 'http://hashcat.net/hashcat/'
  url 'http://hashcat.net/files/hashcat-0.41.7z'
  sha1 '4ca47a77ebd185e3bf31409a10f10a16f337fb82'

  def install
    cd "hashcat-#{version}" do
      prefix.install Dir['*']
      bin.install_symlink "#{prefix}/hashcat-cli64.app" => 'hashcat'
    end
  end

  def test
    system "#{bin}/hashcat --version"
  end
end

require 'formula'

class Hashcat < Formula
  homepage 'http://hashcat.net/hashcat/'
  url 'http://hashcat.net/files/hashcat-0.44.7z'
  sha1 'b07c56532397a1c1552f194e5a1678dfdb4fe64d'

  depends_on 'p7zip'

  def install
    cd "hashcat-#{version}" do
      prefix.install Dir['*']
      bin.install_symlink "#{prefix}/hashcat-cli64.app" => 'hashcat'
    end
  end

  test do
    system "#{bin}/hashcat --version"
  end
end

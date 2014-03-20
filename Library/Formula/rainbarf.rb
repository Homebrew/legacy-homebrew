require 'formula'

class Rainbarf < Formula
  homepage 'https://github.com/creaktive/rainbarf'
  url 'https://github.com/creaktive/rainbarf/archive/v1.1.tar.gz'
  sha1 '9c47f74f7217bf490d32e5964ff8e86f79a9c14c'

  def install
    system 'pod2man', 'rainbarf', 'rainbarf.1'
    man1.install 'rainbarf.1'
    bin.install 'rainbarf'
  end

  test do
    system "#{bin}/rainbarf"
  end
end

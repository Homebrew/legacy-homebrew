require 'formula'

class SafeRm < Formula
  homepage 'http://www.safe-rm.org.nz/'
  url 'https://launchpad.net/safe-rm/trunk/0.10/+download/safe-rm-0.10.tar.gz'
  sha1 '6b829ae68e1fa3c8016e15ab37fcc08caef7712f'

  def install
    bin.install 'safe-rm'
  end

  test do
    file = "a-file"
    touch file
    system "#{bin}/safe-rm", file
    !File.exists? file
  end
end

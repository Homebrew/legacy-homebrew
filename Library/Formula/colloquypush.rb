require 'formula'

class Colloquypush < Formula
  homepage 'https://github.com/wired/colloquypush'
  url 'https://github.com/wired/colloquypush/tarball/colloquy-znc-1.1'
  md5 '6f696b3c36bcbc05975181e129ea8599'

  head 'https://github.com/wired/colloquypush.git'

  depends_on 'znc'

  def install
    cd "znc" do
      system "znc-buildmod", "colloquy.cpp"
      system "install", "-m", "0755", "colloquy.so", %x[znc-config --moddir].strip()
    end
  end
end

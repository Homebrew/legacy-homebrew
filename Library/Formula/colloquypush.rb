require 'formula'

class Colloquypush < Formula
  homepage 'https://github.com/wired/colloquypush'
  url 'https://github.com/wired/colloquypush/archive/colloquy-znc-1.1.tar.gz'
  sha1 '1563eb2c844b7ce4bfefd213fe85ef3e1c7a036a'

  head 'https://github.com/wired/colloquypush.git'

  depends_on 'znc'

  def install
    cd "znc" do
      system "znc-buildmod", "colloquy.cpp"
      system "install", "-m", "0755", "colloquy.so", %x[znc-config --moddir].strip()
    end
  end
end

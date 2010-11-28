require 'formula'

class Colloquypush <Formula
  head 'git://github.com/wired/colloquypush.git'
  homepage 'https://github.com/wired/colloquypush'

  depends_on 'znc'

  def install
    Dir.chdir("znc")
    system "znc-buildmod", "colloquy.cpp"
    system "install", "-m", "0755", "colloquy.so", %x[znc-config --moddir].strip()
  end
end

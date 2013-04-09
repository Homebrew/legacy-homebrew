require 'formula'

class Proxychains < Formula
  homepage 'https://github.com/haad/proxychains.git'
  url "https://github.com/haad/proxychains/archive/proxychains-4.2.0.tar.gz"
  sha1 "15ba3f3f9ec78d8926a7d685db4908f369a8bc2c"
  #head 'https://github.com/haad/proxychains.git'

  def install
    system "./configure", "--prefix=#{prefix} --sysconfdir=#{etc}"
    system "make"
    system "make install"
    bin.install 'proxychains4' => 'proxychains'
    etc.install 'src/proxychains.conf' unless (etc/'proxychains.conf').exist?
  end

  test do
    system "proxychains"
    File.exist? "#{etc}/proxychains.conf"
  end
end

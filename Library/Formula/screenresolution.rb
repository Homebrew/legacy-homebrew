require 'formula'

class Screenresolution < Formula
  homepage 'https://github.com/jhford/screenresolution'
  url 'https://github.com/jhford/screenresolution/archive/v1.6.tar.gz'
  sha1 '5a4c397711c0cadb3cf58e8eb13dff50b993b388'
  head 'https://github.com/jhford/screenresolution.git'

  # Uses CGDisplayModeRef type, introduced in 10.6
  depends_on :macos => :snow_leopard

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/screenresolution", 'get'
  end
end

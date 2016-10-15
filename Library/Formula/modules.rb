require 'formula'

class Modules < Formula
  homepage 'http://modules.sourceforge.net'
  url 'http://sourceforge.net/projects/modules/files/Modules/modules-3.2.10/modules-3.2.10.tar.gz'
  sha1 'a42b03cf59f10c4d06cd8cc1b176f172484a3205'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

end

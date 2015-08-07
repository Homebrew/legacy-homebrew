class Mairix < Formula
  desc "Email index and search tool"
  homepage "http://www.rpcurnow.force9.co.uk/mairix/"
  url "https://downloads.sourceforge.net/project/mairix/mairix/0.23/mairix-0.23.tar.gz"
  sha256 "804e235b183c3350071a28cdda8eb465bcf447092a8206f40486191875bdf2fb"

  head "https://github.com/rc0/mairix.git"

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end

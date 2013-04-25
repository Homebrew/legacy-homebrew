# encoding: UTF-8

require 'formula'

class Paps < Formula
  homepage 'http://paps.sourceforge.net/'
  url 'http://downloads.sourceforge.net/paps/paps-0.6.8.tar.gz'
  sha1 '83646b0de89deb8321f260c2c5a665bc7c8f5928'

  depends_on 'pkg-config' => :build
  depends_on 'pango'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    # http://paps.sourceforge.net/small-hello.utf8
    utf8 = <<-EOS
paps by Dov Grobgeld (דב גרובגלד)
Printing through Παν語 (Pango)

Arabic السلام عليكم
Bengali (বাঙ্লা)  ষাগতোম
Greek (Ελληνικά)  Γειά σας
Hebrew שָׁלוֹם
Japanese  (日本語) こんにちは, ｺﾝﾆﾁﾊ
Chinese  (中文,普通话,汉语) 你好
Vietnamese  (Tiếng Việt)  Xin Chào
    EOS
    safe_system "echo '#{utf8}' |  #{bin}/paps > paps.ps"
  end
end

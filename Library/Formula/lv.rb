require 'formula'

class Lv < Formula
  homepage 'http://www.ff.iij4u.or.jp/~nrt/lv/'
  url 'http://www.ff.iij4u.or.jp/~nrt/freeware/lv451.tar.gz'
  version '4.51'
  md5 '85b70ae797f935741ec9a1cbe92f00e9'

  def install
    cd 'build' do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install 'lv'
    end

    man1.install 'lv.1'
    (lib + 'lv').install 'lv.hlp'
  end
end

require 'formula'

class Gitstats < Formula
  homepage 'http://gitstats.sourceforge.net/'
  version 'latest-20131224'
  url 'https://github.com/hoxu/gitstats.git', :revision => 'a266ddc1ccd281739a916e064756d1f9ac0f1f52'
  sha1 '6d6b8251b3e04b67d7ae4fd8cfec030045bbf8e6'

  def install
    system "make", "install", "PREFIX=#{prefix}" 
  end

  test do
    system "#{bin}/gitstats"
  end
end

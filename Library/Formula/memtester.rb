require 'formula'

class Memtester < Formula
  url 'http://pyropus.ca/software/memtester/old-versions/memtester-4.2.2.tar.gz'
  homepage 'http://pyropus.ca/software/memtester/'
  md5 '0118616cc8860c6b85ef6a1281da1783'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'INSTALLPATH', prefix
      s.gsub! 'man/man8', 'share/man/man8'
    end
    inreplace "conf-ld", " -s", ""
    system "make install"
  end
end

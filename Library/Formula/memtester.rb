require 'formula'

class Memtester < Formula
  url 'http://pyropus.ca/software/memtester/old-versions/memtester-4.2.1.tar.gz'
  homepage 'http://pyropus.ca/software/memtester/'
  md5 '070ced84da42060d65489e6dc1a4211a'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'INSTALLPATH', prefix
      s.gsub! 'man/man8', 'share/man/man8'
    end
    inreplace "conf-ld", " -s", ""
    system "make install"
  end
end

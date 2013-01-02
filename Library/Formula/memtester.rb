require 'formula'

class Memtester < Formula
  homepage 'http://pyropus.ca/software/memtester/'
  url 'http://pyropus.ca/software/memtester/old-versions/memtester-4.3.0.tar.gz'
  sha1 'eff0e3020a7750bd5452b051526ad6439e92b9cd'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'INSTALLPATH', prefix
      s.gsub! 'man/man8', 'share/man/man8'
    end
    inreplace "conf-ld", " -s", ""
    system "make install"
  end
end

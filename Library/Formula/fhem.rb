require 'formula'

class Fhem < Formula
  homepage 'http://fhem.de/fhem.html'
  url 'http://fhem.de/fhem-5.3.tar.gz'
  sha1 'b347cc520298500dea5140538b31de9eacbc8bb1'

  depends_on 'Device::SerialPort' => :perl

  def install

    inreplace 'Makefile' do |s|
      s.change_make_var! "BINDIR", prefix
      s.change_make_var! "ETCDIR", etc
      s.change_make_var! "VARDIR", var+"log/fhem"
      s.change_make_var! "MANDIR", doc
      s.change_make_var! "RELATIVE_PATH", FALSE
    end
    
    system "make install"
  end

  def caveats
     'Start fhem with perl /usr/local/Cellar/fhem/5.3/fhem.pl '+etc+'/fhem.cfg'
  end

end

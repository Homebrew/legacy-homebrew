require 'formula'

class Ttytter < ScriptFileFormula
  homepage 'http://www.floodgap.com/software/ttytter/'
  url 'http://www.floodgap.com/software/ttytter/dist1/1.2.05.txt'
  md5 '8d0e3a65b1ffb91983efcd6351414c81'

  def install
    bin.install '1.2.05.txt' => 'ttytter'
  end

  def caveats; <<-EOS.undent
      To take full advantage of readline features you must install readline:
          brew install readline

      and the Perl Module Term::ReadLine::TTYtter
          cpan -i Term::ReadLine::TTYtter

      Or if you have cpanminus:
          cpanm Term::ReadLine::TTYtter
    EOS
  end
end

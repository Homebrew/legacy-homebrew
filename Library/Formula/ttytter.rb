require 'formula'

class Ttytter < ScriptFileFormula
  homepage 'http://www.floodgap.com/software/ttytter/'
  url 'http://www.floodgap.com/software/ttytter/dist2/2.0.01.txt'
  md5 'd376174a7b04af1066fde9b8cadef972'

  def install
    bin.install '2.0.01.txt' => 'ttytter'
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

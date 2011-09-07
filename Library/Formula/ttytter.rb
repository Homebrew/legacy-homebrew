require 'formula'

class Ttytter < ScriptFileFormula
  url 'http://cdkaiser.sdf.org/ttytter/dist1/1.2.01.txt'
  homepage 'http://cdkaiser.sdf.org/ttytter/'
  md5 'eb7060467236c8ed4e758a7a88832234'

  def install
    bin.install '1.2.01.txt' => 'ttytter'
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

require 'formula'

class Ttytter < ScriptFileFormula
  homepage 'http://www.floodgap.com/software/ttytter/'
  url 'http://www.floodgap.com/software/ttytter/dist2/2.1.00.txt'
  sha1 'dd20d55aa819699b3e39ca4c35bf390b3e074db3'

  def install
    bin.install '2.1.00.txt' => 'ttytter'
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

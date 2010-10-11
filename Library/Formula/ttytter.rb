require 'formula'

class Ttytter <ScriptFileFormula
  url 'http://www.floodgap.com/software/ttytter/dist1/1.1.06.txt'
  homepage 'http://www.floodgap.com/software/ttytter/'
  md5 'cfb9a2b9334c194ace2d695bf01a3025'
  
  

  def install
    bin.install '1.1.06.txt' => 'ttytter'
  end  
      def caveats; <<-EOS
    To take full advantage of the new readline feature you have to install readline:
    brew install readline
    and the Perl Module Term::ReadLine::TTYtter 
    use cpan -i Term::ReadLine::TTYtter
    or if you brewed cpanminus use
    cpanm Term::ReadLine::TTYtter
    EOS
  end
end

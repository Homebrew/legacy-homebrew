require 'formula'

class Texapp < Formula
  homepage 'http://www.floodgap.com/software/texapp/'
  url 'http://www.floodgap.com/software/texapp/dist0/0.6.04.txt'
  sha1 '023a2e2ebf6ea2cac503501e8939124b2a73896a'

  def install
    bin.install "#{version}.txt" => "texapp"
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

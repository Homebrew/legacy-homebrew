require 'formula'

class Texapp < Formula
  homepage 'http://www.floodgap.com/software/texapp/'
  url 'http://www.floodgap.com/software/texapp/dist0/0.6.00.txt'
  sha1 'b9f07560d1182d6d35064ef25a6a3da7362d563c'

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

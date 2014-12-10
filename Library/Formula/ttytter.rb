require 'formula'

class Ttytter < Formula
  homepage 'http://www.floodgap.com/software/ttytter/'
  url 'http://www.floodgap.com/software/ttytter/dist2/2.1.00.txt'
  sha1 'a72b2c4b7da8a370ff15c7f5a1a3ecf9056590f0'

  def install
    bin.install "#{version}.txt" => "ttytter"
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

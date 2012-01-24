require 'formula'

class Open2300 < Formula
  url 'http://downloads.sourceforge.net/project/open2300/open2300/1.10/open2300-1.10.tar.gz'
  homepage 'http://www.lavrsen.dk/foswiki/bin/view/Open2300/WebHome'
  md5 '4405949ffec0306405436e5e096ced8f'

  # depends_on 'cmake' => :build

  def install
      
      inreplace 'Makefile' do |s|
          s.gsub! '/usr/local', prefix
      end
      
      system "make"
      system "make install"
      etc.install "open2300-dist.conf" => "open2300.conf"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test open2300`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end

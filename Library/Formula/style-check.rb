require 'formula'

class StyleCheck < Formula
  url 'http://www.cs.umd.edu/~nspring/software/style-check-0.13.tar.gz'
  homepage 'http://www.cs.umd.edu/~nspring/software/style-check-readme.html'
  md5 '60eab1aa903217455dcd0f8997949c94'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'PREFIX', prefix
      s.change_make_var! 'SYSCONFDIR', (etc+'style-check.d')
    end
    inreplace "style-check.rb", '/etc/style-check.d/', (etc+'style-check.d/')

    system "make install"
  end
end

require 'formula'

class Phantomjs <Formula
  head "git://github.com/ariya/phantomjs.git"
  homepage 'http://code.google.com/p/phantomjs/'

  depends_on 'qt'

  def install
    system "qmake -spec macx-g++" 
    system "make"
    
    %w[examples bin ChangeLog LICENSE.BSD README.md].each {|f| prefix.install f}
    ln_s prefix+"bin/phantomjs.app/Contents/MacOS/phantomjs", bin+"phantomjs"
  end
end

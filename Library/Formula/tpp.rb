require 'formula'

class Tpp < Formula
  url 'http://synflood.at/tpp/tpp-1.3.1.tar.gz'
  homepage 'http://synflood.at/tpp.html'
  md5 '35eebb38497e802df1faa57077dab2d1'

  depends_on 'ncurses' => :ruby
  depends_on 'figlet' => :optional

  def install
    bin.install 'tpp.rb' => 'tpp'
  end
end

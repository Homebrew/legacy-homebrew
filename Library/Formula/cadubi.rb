require 'formula'

class Cadubi < Formula
  homepage 'http://langworth.com/pub/cadubi/'
  url 'http://langworth.com/pub/cadubi-1.3.tar.gz'
  sha1 '3071b6ce1fce911f37eae3e01bef932d3cfb11d8'

  def install
    inreplace 'cadubi', '$Bin/help.txt', "#{doc}/help.txt"
    bin.install 'cadubi'
    doc.install 'help.txt'
  end
end

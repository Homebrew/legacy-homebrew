require 'formula'

class Cadubi < Formula
  url 'http://pub.langworth.com/cadubi-1.3.tar.gz'
  homepage 'http://langworth.com/pub/cadubi/'
  md5 'e4ba1f6995bfdae8639341446782b859'

  depends_on 'Term::ReadKey' => :perl

  def install
    inreplace 'cadubi', '$Bin/help.txt', "#{doc}/help.txt"
    bin.install 'cadubi'
    doc.install 'help.txt'
  end

  def test
    # This should really test that the help file was installed
    # correctly, but that's not an easy task.
    system "cadubi --version 2>&1 | grep 'Creative ASCII'"
  end
end

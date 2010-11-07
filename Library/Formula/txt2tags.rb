require 'formula'

class Txt2tags <Formula
  url 'http://txt2tags.googlecode.com/files/txt2tags-2.6.tgz'
  homepage 'http://txt2tags.org'
  md5 'ac09fd624f1e3a553d5f0e01271cc0ee'

  def install
    bin.install('txt2tags')
    prefix.install Dir['*']
    # TODO - install man files in the correct path
  end
end

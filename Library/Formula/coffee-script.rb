require 'formula'

class CoffeeScript <Formula
  url 'http://github.com/jashkenas/coffee-script/tarball/0.7.2'
  head 'git://github.com/jashkenas/coffee-script.git'
  homepage 'http://jashkenas.github.com/coffee-script/'
  md5 'cfccf25272d329bc78349771b18fe4e0'

  # head coffee-script usually depends on head node and
  # since there isn't a way to specify that just remove
  # the depends_on
  depends_on :node unless ARGV.flag? '--HEAD'

  def caveats
    <<-EOS.undent
    Coffee is a continually evolving language and as such uses new features of
    Node.js as they are added.  To take advantage of these features while using
    HEAD make sure to install the HEAD version of node and keep it updated.

        brew uninstall node
        brew install node --HEAD
    EOS
  end if ARGV.flag? '--HEAD'

  def install
    bin.mkpath
    system "./bin/cake", "--prefix", prefix, "install"
  end
end

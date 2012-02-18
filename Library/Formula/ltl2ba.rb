require 'formula'

class Ltl2ba < Formula
  url 'http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/ltl2ba-1.1.tar.gz'
  homepage 'http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/'
  md5 'bb7fdef7e2b5d963fa04d63f231ae180'

  def install
    system "make"
    system "install ltl2ba #{prefix}"
  end
end

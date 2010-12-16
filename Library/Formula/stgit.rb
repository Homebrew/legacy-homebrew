require 'formula'

class Stgit <Formula
  url 'http://download.gna.org/stgit/stgit-0.15.tar.gz'
  homepage 'http://www.procode.org/stgit'
  md5 'a4721b2a5f529cf5450109f9fcb4db19'

  def install
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end
end

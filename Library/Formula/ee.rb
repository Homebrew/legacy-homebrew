require 'formula'

class Ee <Formula
  url 'http://www.users.qwest.net/~hmahon/sources/ee-1.4.6.src.tgz'
  homepage 'http://www.users.qwest.net/~hmahon/'
  md5 '447c48341fc355dacc7e5d338dd1677a'

  def install
    system "make localmake"
    system "make all"

    # Install manually
    bin.install "ee"
    man1.install "ee.1"
  end
end

require 'formula'

class Gosu <Formula
  url 'http://gosu-lang.org/downloads/gosu-0.7.0-C.zip'
  version '0.7.0-C'
  homepage 'http://gosu-lang.org/'
  md5 '08e48e57813ecb9967109e4d4dea618e'

  def install
    mv "bin/gosu.sh", "bin/gosu"
    touch "ext/.anchor"
    prefix.install Dir['*']
  end
end

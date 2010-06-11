require 'formula'

class Cowsay <Formula
  url 'http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz'
  homepage 'http://www.nog.net/~tony/warez/cowsay.shtml'
  md5 'b29169797359420dadb998079021a494'

  aka 'cowthink'

  def install
    system "/bin/sh", "install.sh", prefix
    FileUtils.mv prefix+'man', share
  end
end

require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://download.playframework.org/releases/play-2.0.zip'
  md5 '5b429c991be607c8e41203579c6b506e'

  def install
    rm Dir['*.bat'] # remove windows' bat files
    libexec.install Dir['*']
    inreplace libexec+"play", "$dir/", "$dir/../libexec/"
    inreplace libexec+"play", "dir=`dirname $PRG`", "dir=`dirname $0` && dir=$dir/`dirname $PRG`"
    bin.install_symlink libexec+'play'
  end
end
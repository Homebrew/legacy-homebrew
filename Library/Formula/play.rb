require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://download.playframework.org/releases/play-2.0.3.zip'
  md5 '299ed2e0b5242fc02b3db74bd95db68e'

  def install
    rm Dir['*.bat'] # remove windows' bat files
    libexec.install Dir['*']
    inreplace libexec+"play" do |s|
      s.gsub! "$dir/", "$dir/../libexec/"
      s.gsub! "dir=`dirname $PRG`", "dir=`dirname $0` && dir=$dir/`dirname $PRG`"
    end
    bin.install_symlink libexec+'play'
  end
end

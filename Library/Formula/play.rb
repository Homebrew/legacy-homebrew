require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://downloads.typesafe.com/play/2.1.2/play-2.1.2.zip'
  sha1 'b6d8716a54219b40ffc678656c4763e360258bf7'

  head 'https://github.com/playframework/Play20.git'

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

require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://downloads.typesafe.com/play/2.1.1/play-2.1.1.zip'
  sha1 '3b1a0c3ca23dde36113d935b85d7f4d45f05923b'

  head 'https://github.com/playframework/Play20.git'

  devel do
    url 'http://downloads.typesafe.com/play/2.1.2-RC1/play-2.1.2-RC1.zip'
    sha1 '61e1ee829ea5bec826dc4237ebb6dcab3e47feb7'
  end

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

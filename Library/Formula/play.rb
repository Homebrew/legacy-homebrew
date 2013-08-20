require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://downloads.typesafe.com/play/2.1.3/play-2.1.3.zip'
  sha1 'f399da960980edc929011c07ef64ee868eca8a9f'

  head 'https://github.com/playframework/Play20.git'

  devel do
    url 'http://downloads.typesafe.com/play/2.2.0-M2/play-2.2.0-M2.zip'
    version '2.2.0-M2'
    sha1 '8c4d7393b8d50da4e02b59c67da2379710a305ea'
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

require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://download.playframework.org/releases/play-2.0.1.zip'
  md5 'f860f006a713a6c9949c4c3f3efc33fb'

  devel do
    url 'http://download.playframework.org/releases/play-2.0-RC4.zip'
    md5 '98a9bbe198ca75146dfac813af5cfdbd'
  end
  
  def install
<<<<<<< HEAD
    rm_rf 'python' unless ARGV.build_devel? # we don't need the bundled Python for windows, and has been removed in the RC builds
    rm Dir['*.bat']
=======
    rm Dir['*.bat'] # remove windows' bat files
>>>>>>> master
    libexec.install Dir['*']
    inreplace libexec+"play" do |s|
      s.gsub! "$dir/", "$dir/../libexec/"
      s.gsub! "dir=`dirname $PRG`", "dir=`dirname $0` && dir=$dir/`dirname $PRG`"
    end
    bin.install_symlink libexec+'play'
    
    # For some reason, play is attempting to unfuck things if the play script is a symlink.
    inreplace "#{libexec}/play", "dir=`dirname $PRG`", "dir=#{libexec}" if ARGV.build_devel?
  end
end

require 'formula'

class Play < Formula
  homepage 'http://www.playframework.org/'
  url 'http://download.playframework.org/releases/play-1.2.4.zip'
  md5 'ec8789f8cc02927ece536d102f5e649e'

  devel do
    url 'http://download.playframework.org/releases/play-2.0-RC4.zip'
    md5 '98a9bbe198ca75146dfac813af5cfdbd'
  end
  
  def install
    rm_rf 'python' unless ARGV.build_devel? # we don't need the bundled Python for windows, and has been removed in the RC builds
    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.install_symlink libexec+'play'
  end
end

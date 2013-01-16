require 'formula'

class Metasploit < Formula
  homepage 'http://www.metasploit.com/framework/'
  url 'http://downloads.metasploit.com/data/releases/framework-4.5.0.tar.bz2'
  sha1 '13c3e4ef5265ecb5b6303d39ca1347982b782886'

  head "https://github.com/rapid7/metasploit-framework.git", :using => :git

  def install
    libexec.install Dir['.svn','armitage','HACKING',"msf*",'data','documentation','external','lib','modules','plugins','scripts','test','tools']
    bin.install_symlink Dir["#{libexec}/msf*","#{libexec}/armitage"]
  end
end

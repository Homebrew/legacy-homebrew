require 'formula'

class Metasploit < Formula
  homepage 'http://www.metasploit.com/framework/'
  url 'https://github.com/rapid7/metasploit-framework.git', :using => :git, :tag => '2013010902'
  version '4.5.0-2013010902'

  head "https://github.com/rapid7/metasploit-framework.git", :using => :git

  def install
    libexec.install Dir['.svn','armitage','HACKING',"msf*",'data','documentation','external','lib','modules','plugins','scripts','test','tools']
    bin.install_symlink Dir["#{libexec}/msf*","#{libexec}/armitage"]
  end
end

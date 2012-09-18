require 'formula'

class Metasploit < Formula
  homepage 'http://www.metasploit.com/framework/'
  url 'http://downloads.metasploit.com/data/releases/archive/framework-4.3.0.tar.bz2'
  sha1 '45eea26b27ffe5bcd2dc25888bad897fcdd35bfb'

  head "https://www.metasploit.com/svn/framework3/trunk/", :using => :svn

  # Metasploit's tarball comes with a full .svn checkout.
  # Don't clean these folders, so users can "svn up" to update
  # metasploit in-place, which apparently is standard for this project.
  skip_clean :all

  def install
    libexec.install Dir['.svn','armitage','HACKING',"msf*",'data','documentation','external','lib','modules','plugins','scripts','test','tools']
    bin.install_symlink Dir["#{libexec}/msf*","#{libexec}/armitage"]
  end

  def caveats; <<-EOS.undent
    Metasploit can be updated in-place by doing:
      cd `brew --prefix metasploit`/libexec/
      svn up
    EOS
  end
end

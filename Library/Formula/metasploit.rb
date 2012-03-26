require 'formula'

class Metasploit < Formula
  homepage 'http://www.metasploit.com/framework/'
  url "http://updates.metasploit.com/data/releases/framework-4.1.0.tar.bz2"
  sha1 'f978b82d0b5d65e2958006aa9a6fca01573b9539'

  head "https://www.metasploit.com/svn/framework3/trunk/", :using => :svn

  # Metasploit's tarball comes with a full .svn checkout.
  # Don't clean these folders, so users can "svn up" to update
  # metasploit in-place, which apparently is standard for this project.
  skip_clean :all

  def install
    libexec.install Dir["msf*",'data','external','lib','modules','plugins','scripts','test','tools']
    bin.install_symlink Dir["#{libexec}/msf*"]
  end

  def caveats; <<-EOS.undent
    Metasploit can be updated in-place by doing:
      cd `brew --prefix metasploit`/libexec/
      svn up
    EOS
  end
end

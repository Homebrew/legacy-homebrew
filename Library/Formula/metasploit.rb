require 'formula'

class Metasploit <Formula
  head "https://www.metasploit.com/svn/framework3/trunk/", :using => :svn, :revision => "9321"
  version "3.4.0"
  homepage 'http://www.metasploit.com/framework/'
  md5 ''

  def install
    libexec.install Dir["msf*",'data','external','lib','modules','plugins','scripts','test','tools']
    bin.mkpath
    Dir["#{libexec}/msf*"].each {|f| ln_s f, bin}
  end
end

require 'formula'

class Metasploit <Formula
  url "http://updates.metasploit.com/data/releases/framework-3.5.2.tar.bz2"
  head "https://www.metasploit.com/svn/framework3/trunk/", :using => :svn, :revision => "HEAD"
  homepage 'http://www.metasploit.com/framework/'

  if not ARGV.build_head?
    @sha1 = "981ebf88e0bb65c65293c44185f8c4229137607f"
  end

  def install
    libexec.install Dir["msf*",'data','external','lib','modules','plugins','scripts','test','tools']
    bin.mkpath
    Dir["#{libexec}/msf*"].each {|f| ln_s f, bin}
  end
end

require 'formula'

class Flvtoolxx <Formula
  url 'http://mirror.facebook.net/facebook/flvtool++/flvtool++-1.2.1.tar.gz'
  homepage 'http://developers.facebook.com/opensource/'
  md5 'a8c4c578b4c6741a94ca6eb197a01fe1'
  version '1.2.1'
  depends_on 'scons'
  depends_on 'boost'

  def install
    system 'scons'
    prefix.install 'flvtool++'
    ln_s("#{prefix}/flvtool++", "#{HOMEBREW_PREFIX}/bin/flvtool++")
  end
  
  def caveats; <<-EOF
      NOTE: A symlink has been created at #{HOMEBREW_PREFIX}/bin/flvtool++
      When uninstalling flvtool++ this symlink needs to be removed manually.
  EOF
  end
end
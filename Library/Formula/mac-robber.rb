require 'formula'

class MacRobber <Formula
  url 'http://downloads.sourceforge.net/project/mac-robber/mac-robber/1.02/mac-robber-1.02.tar.gz'
  homepage 'http://www.sleuthkit.org/mac-robber/'
  md5 '6d6d99aa882a46b2bc5231d195fdb595'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "GCC_OPT", ENV.cflags
    end
    system "make"
    bin.install 'mac-robber'
  end
end

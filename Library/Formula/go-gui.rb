require 'formula'

class GoGui < Formula
  url 'http://downloads.sourceforge.net/project/gogui/gogui/1.2.2/gogui-1.2.2.zip'
  homepage 'http://gogui.sourceforge.net'
  md5 'a222d7f5f654341dc55016fd4c1d512f'

  def install
    system "ant"
    system "ant", "gogui.app"
    prefix.install ['build/GoGui.app']
  end

  def caveats; <<-EOS.undent
    GoGui.app installed to:
      #{prefix}
    Use \"brew linkapps\" to symlink into ~/Applications.
    EOS
  end
end

require 'formula'

class GoGui < Formula
  homepage 'http://gogui.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/gogui/gogui/1.4.2/gogui-1.4.2.zip'
  md5 '0f5e95deff548699c368b71e088bea58'

  def install
    system "ant", "gogui.app", "-Ddoc-uptodate=true"
    prefix.install 'build/GoGui.app'
  end

  def caveats; <<-EOS.undent
    GoGui.app installed to:
      #{prefix}
    Use \"brew linkapps\" to symlink into ~/Applications.
    EOS
  end
end

require 'formula'

class QtCreator < Formula
  url 'http://get.qt.nokia.com/qtcreator/qt-creator-2.2.1-src.zip'
  homepage 'http://qt.nokia.com/'
  md5 '8a3165f7f68d4932c9a902452993099d'

  depends_on 'qt'

  def install
    system "qmake"
    system "make"
    prefix.install "bin/Qt Creator.app"
  end
 
  def caveats; <<-EOS
To place Qt Creator link in ~/Applications run:
    brew linkapps
or 
    ln -sf "#{prefix}/Qt Creator.app" ~/Applications

It can not find Qt in PATH because it inherits PATH from Finder, not from ~/.profile
To make Qt Creator find Qt in PATH edit or create ~/.MacOSX/environment.plist like this:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
        <dict>
            <key>PATH</key>
            <string>/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin</string>
        </dict>
    </plist>
EOS
  end

end

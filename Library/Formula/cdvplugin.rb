require 'formula'
class Cdvplugin < Formula
    homepage 'http://randymcmillan.github.com/CDVPlugin'
    url 'https://github.com/RandyMcMillan/CDVPlugin/archive/cdv230.tar.gz'
    head 'https://github.com/RandyMcMillan/CDVPlugin.git'
    version 'CDVPlugin'
    sha1 '6afabc3ce1459e6d9340f7ba18e6c39ffaacdf4b'

    def install
    prefix.install Dir['*']
    system 'ln -s /usr/local/Cellar/cdvplugin/CDVPlugin ~/Library/Developer/Xcode/Templates/File\ Templates/CDVPlugin\ 2.2'
    end
end

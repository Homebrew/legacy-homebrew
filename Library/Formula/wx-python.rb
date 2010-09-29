require 'formula'

#Once wxmac pointing to a 2.9 release we can use it for the wx dep ala:
#require Formula.path('wxmac')
#
#Until then specify our own dependency here (only used for building head)
class WxPythonDependency <Formula
  url 'http://downloads.sourceforge.net/project/wxwindows/2.9.2/wxWidgets-2.9.2.tar.bz2'
  homepage 'http://www.wxwidgets.org'
  md5 'd6cec5bd331ba90b74c1e2fcb0563620'
end

class WxPython <Formula
  url 'http://downloads.sourceforge.net/project/wxpython/wxPython/2.9.2.1/wxPython-src-2.9.2.1.tar.bz2'
  head 'http://svn.wxwidgets.org/svn/wx/wxPython/trunk/',
    :using => StrictSubversionDownloadStrategy
  homepage 'http://www.wxpython.org'
  md5 '1cb1e0757cda9afe2da35d5ee0003262'

  def install
    if ARGV.build_head?
      wxdir = Pathname.getwd + 'wxWidgets'
      WxPythonDependency.new.brew { wxdir.install Dir['*'] }
      ENV['WXWIN'] = wxdir.to_s if ARGV.build_head?
    else
      cd "wxPython"
    end

    system "python", "build-wxpython.py", "--osx_cocoa", "--install", "--prefix=#{prefix}"
  end
end

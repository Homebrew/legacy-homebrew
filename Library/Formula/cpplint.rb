require 'formula'

class Cpplint < Formula
  head 'http://google-styleguide.googlecode.com/svn/trunk/cpplint', :using => :svn
  def install
    inreplace 'cpplint.py' do |s|
      s.gsub! "/usr/bin/python2.4", "/usr/bin/env python"
    end
    bin.install 'cpplint.py'
  end
end

require 'formula'

class Blazeblogger < Formula
  homepage 'http://blaze.blackened.cz/'
  url 'https://blazeblogger.googlecode.com/files/blazeblogger-1.2.0.tar.gz'
  sha1 '280894fca6594d0c0df925aa0a16b9116ee19f17'

  def install
    system "make", "prefix=#{prefix}",
                   "compdir=#{prefix}",
                   "install"
  end
end

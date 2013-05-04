require 'formula'

class Timedog < Formula
  homepage 'http://timedog.googlecode.com/'
  url 'http://timedog.googlecode.com/files/timedog-1.2.zip'
  sha1 '620a4615ba4a03dc8d7ae2f7259b9ab8daf267c6'

  def install
    bin.install 'timedog'
  end
end

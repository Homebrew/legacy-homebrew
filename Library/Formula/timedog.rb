require 'formula'

class Timedog < Formula
  url 'http://timedog.googlecode.com/files/timedog-1.2.zip'
  sha1 '620a4615ba4a03dc8d7ae2f7259b9ab8daf267c6'
  homepage 'http://timedog.googlecode.com/'

  def install
    bin.install 'timedog'
  end
end

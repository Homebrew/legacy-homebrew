require 'formula'

class Xpl2gpl < Formula
  homepage 'http://tcptrace.org/xpl2gpl/'
  url 'http://www.tcptrace.org/useful/xpl2gpl/xpl2gpl'
  sha1 '0586f17a8f8e1461a53910db5888d8228586a742'
  version '0'

  def install
    bin.install 'xpl2gpl'
  end
end

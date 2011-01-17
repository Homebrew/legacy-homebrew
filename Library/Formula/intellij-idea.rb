require 'formula'

class IntellijIdea <Formula
  url 'http://download.jetbrains.com/idea/ideaIC-10-src.tar.bz2'
  homepage 'http://www.jetbrains.org/display/IJOS/'
  md5 '89d5fd89375b34b47cd6f478d463845c'
  version '10'

  def install
    system 'ant'
  end
end

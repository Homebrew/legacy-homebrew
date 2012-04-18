require 'formula'

class Getmail < Formula
  homepage 'http://pyropus.ca/software/getmail/'
  url 'http://pyropus.ca/software/getmail/old-versions/getmail-4.26.0.tar.gz'
  sha1 'b350c98db9883365444c59e06ffc6672c68fa0f7'

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end
end

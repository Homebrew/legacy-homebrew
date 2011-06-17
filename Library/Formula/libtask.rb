require 'formula'

class Libtask < Formula
  head 'https://libtask.googlecode.com/hg/'
  homepage 'http://swtch.com/libtask/'

  def install
    system "make"
    lib.install ['libtask.a']
    include.install ['task.h']
  end
end

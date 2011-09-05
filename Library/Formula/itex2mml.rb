# From: Jacques Distler <distler@golem.ph.utexas.edu>
# You can always find the latest version by checking
#    http://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h
# The corresponding versioned archive is
#    http://golem.ph.utexas.edu/~distler/blog/files/itexToMML-x.x.x.tar.gz

require 'formula'

class Itex2mml < Formula
  url 'http://golem.ph.utexas.edu/~distler/blog/files/itexToMML-1.4.9.tar.gz'
  homepage 'http://golem.ph.utexas.edu/~distler/blog/itex2MML.html'
  md5 '156a20b8d04e85f07cf4eb992e0756fb'

  def install
    Dir.chdir("itex-src") do
      system "make"
      bin.mkpath
      system "make", "install", "prefix=#{prefix} BINDIR=#{bin}"
    end
  end

  def test
    system "#{bin}/itex2MML --version"
  end

end

require 'formula'

# From: Jacques Distler <distler@golem.ph.utexas.edu>
# You can always find the latest version by checking
#    http://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h
# The corresponding versioned archive is
#    http://golem.ph.utexas.edu/~distler/blog/files/itexToMML-x.x.x.tar.gz

class Itex2mml < Formula
  homepage 'http://golem.ph.utexas.edu/~distler/blog/itex2MML.html'
  url 'http://golem.ph.utexas.edu/~distler/blog/files/itexToMML-1.5.0.tar.gz'
  sha1 'd30ac4327f4e9dc5259950404b45671eb241945e'

  def install
    bin.mkpath
    cd "itex-src" do
      system "make"
      system "make", "install", "prefix=#{prefix}", "BINDIR=#{bin}"
    end
  end

  test do
    system "#{bin}/itex2MML", "--version"
  end
end

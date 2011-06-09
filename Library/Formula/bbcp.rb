require 'formula'

class Bbcp < Formula
  head 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.tgz'
  homepage 'http://www.slac.stanford.edu/~abh/bbcp/'

  def install
    cd 'src' do
      system 'make'
    end
    bindir = `./MakeSname`.chomp
    bin.install "bin/#{bindir}/bbcp"
  end
end

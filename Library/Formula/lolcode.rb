require 'formula'

class Lolcode < Formula
  homepage 'http://www.icanhaslolcode.org/'
  url 'https://github.com/justinmeza/lci/tarball/v0.9.2'
  head 'git://github.com/justinmeza/lolcode.git'
  md5 'bb757687aabea302351cbbce77e01c26'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "prefix", prefix
    end

    system "make"

    # v0.9.2 should use 'make install'.
    # Later versions can just copy the 'lolcode' bin.
    if ARGV.build_head?
      bin.install 'lolcode'
    else
      bin.mkpath
      system "make install"
    end
  end
end

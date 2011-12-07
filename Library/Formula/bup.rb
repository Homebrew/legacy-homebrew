require 'formula'

class Bup < Formula
  head 'git://github.com/apenwarr/bup.git', :using => :git
  homepage 'https://github.com/apenwarr/bup#readme'

  def install
    inreplace 'Makefile' do |s| 
      s.change_make_var! "PREFIX", prefix
    end

    system "make install"
  end
end

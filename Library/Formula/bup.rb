require 'formula'

class Bup < Formula
  url 'https://github.com/apenwarr/bup/tarball/bup-0.25-rc1'
  sha1 '96760b4cca5b4655cb79caaafd2ce2e70a242a7a'
  homepage 'https://github.com/apenwarr/bup#readme'

  def install
    inreplace 'Makefile' do |s| 
      s.change_make_var! "PREFIX", prefix
    end

    system "make install"
  end
end

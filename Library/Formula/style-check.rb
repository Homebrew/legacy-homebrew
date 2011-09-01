require 'formula'

class StyleCheck < Formula
  url 'http://www.cs.umd.edu/~nspring/software/style-check-0.14.tar.gz'
  homepage 'http://www.cs.umd.edu/~nspring/software/style-check-readme.html'
  md5 'b88b0632b80abf9c8aaa2c5f2c3e2934'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'PREFIX', prefix
      s.change_make_var! 'SYSCONFDIR', (etc+'style-check.d')
    end
    inreplace "style-check.rb", '/etc/style-check.d/', (etc+'style-check.d/')

    system "make install"
  end
end

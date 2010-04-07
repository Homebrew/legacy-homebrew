require 'formula'

class Greg <Formula
  head 'http://github.com/nddrylliog/greg.git'
  homepage 'http://github.com/nddrylliog/greg'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "PREFIX", prefix
    end

    bin.mkdir
    system "make install"
  end
end

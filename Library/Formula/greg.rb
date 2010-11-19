require 'formula'

class Greg <Formula
  head 'https://github.com/nddrylliog/greg.git'
  homepage 'https://github.com/nddrylliog/greg'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "PREFIX", prefix
    end

    bin.mkdir
    system "make install"
  end
end

require 'formula'

class Tofrodos < Formula
  homepage 'http://www.thefreecountry.com/tofrodos/'
  url 'http://tofrodos.sourceforge.net/download/tofrodos-1.7.13.tar.gz'
  sha1 '665cff074a19030705eb80274f483f20aa24b38e'

  def install
    cd 'src' do
      system "make"
      bin.install %w[todos fromdos]
      man1.install "fromdos.1"
      man1.install_symlink "fromdos.1" => "todos.1"
    end
  end
end

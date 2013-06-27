require 'formula'

class Hubflow < Formula
  homepage 'http://datasift.github.io/gitflow/'
  url 'https://github.com/datasift/gitflow.git', :revision => 'd4e8de95acf88195051015df13158d755174c322'
  version '1.5.1'

  def install
    ENV['INSTALL_INTO'] = bin
    system "./install.sh", "install"
  end

  test do
    system "git-hf", "version"
  end
end

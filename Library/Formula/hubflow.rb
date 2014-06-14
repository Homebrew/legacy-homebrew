require 'formula'

# Note: pull from git tag to get submodules
class Hubflow < Formula
  homepage 'http://datasift.github.io/gitflow/'
  url 'https://github.com/datasift/gitflow.git', :tag => '1.5.2'

  def install
    ENV['INSTALL_INTO'] = libexec
    system "./install.sh", "install"
    bin.write_exec_script libexec/'git-hf'
  end

  test do
    system bin/"git-hf", "version"
  end
end

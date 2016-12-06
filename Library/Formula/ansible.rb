require 'formula'

class Ansible < Formula
  homepage 'http://www.ansibleworks.com'
  url 'http://ansibleworks.com/releases/ansible-1.2.tar.gz'
  sha1 'fcc2d4b1b4ada59f6250c163ccf91b4c051ba0bc'

  depends_on :python
  depends_on 'pyaml'    => :python
  depends_on 'jinja2'   => :python
  depends_on 'paramiko' => :python

  def install
    # rewrite hardcoded references to /usr/share
    inreplace "setup.py", "DIST_MODULE_PATH + i", "i"
    inreplace "lib/ansible/constants.py", "DIST_MODULE_PATH = '/usr/share/ansible/'", "DIST_MODULE_PATH = '#{prefix}'"
    system python, "setup.py", "build"
    system python, "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "ansible --version"
  end
end

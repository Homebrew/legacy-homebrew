require 'formula'

class Pssh <Formula
  url 'http://parallel-ssh.googlecode.com/files/pssh-2.1.1.tar.gz'
  homepage 'http://code.google.com/p/parallel-ssh/'
  md5 '4b355966da91850ac530f035f7404cd5'

  depends_on 'python'
  depends_on 'setuptools' => :python

  def install
    system "python", "setup.py", "install"
    Dir["bin/*"].each do |filename|
      bin.install(filename)
    end
  end
end

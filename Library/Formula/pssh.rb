require 'formula'

class Pssh <Formula
  url 'http://parallel-ssh.googlecode.com/files/pssh-2.2.2.tar.gz'
  homepage 'http://code.google.com/p/parallel-ssh/'
  md5 '865305ae39647884bc54a42e9f9554bb'
  version '2.2.2'

  def install
    system "python", "setup.py", "install",
                                 "--prefix=#{prefix}"
  end
end


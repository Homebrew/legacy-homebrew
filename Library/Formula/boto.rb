require 'formula'

class Boto <Formula
  url 'http://boto.googlecode.com/files/boto-2.0b2.tar.gz'
  homepage 'http://code.google.com/p/boto/'
  md5 '7cb6859f0ad40285c068f38e88d02a6e'

  def install
    ENV.universal_binary
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end

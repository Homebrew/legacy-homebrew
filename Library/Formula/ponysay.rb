require 'formula'

class Ponysay < Formula
  homepage 'http://erkin.co/ponysay/'
  url 'https://github.com/erkin/ponysay/archive/3.0.1.tar.gz'
  sha1 'bb867de2cf20a4bc454143d214c8968a0bdbe715'

  depends_on :python3
  depends_on "coreutils"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end
end

require 'formula'

class Ranger <Formula
  url 'http://nongnu.org/ranger/ranger-stable.tar.gz'
  version '1.2.3'
  homepage 'http://ranger.nongnu.org/'
  md5 '11fda1144d85532786ddc59221147884'

  def install
    man1.install 'doc/ranger.1'
    libexec.install ['ranger.py', 'ranger']
    bin.mkpath
    ln_s libexec+'ranger.py', bin+'ranger'
  end
end

require 'formula'

class ClassDumpZ <Formula
  url 'http://networkpx.googlecode.com/files/class-dump-z_0.2a.tar.gz'
  homepage 'http://code.google.com/p/networkpx/wiki/class_dump_z'
  md5 '220d9098c9ce7b03378b9d12b2509ca8'

  skip_clean "mac_x86"
  def install
    bin.install 'mac_x86/class-dump-z'
  end
end
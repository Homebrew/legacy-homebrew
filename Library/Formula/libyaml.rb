require 'formula'

class Libyaml < Formula
  url 'http://pyyaml.org/download/libyaml/yaml-0.1.3.tar.gz'
  homepage 'http://pyyaml.org/wiki/LibYAML'
  md5 'b8ab9064e8e0330423fe640de76608cd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

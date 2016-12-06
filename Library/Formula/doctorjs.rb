require 'formula'

class Doctorjs < Formula
  url 'https://github.com/mozilla/doctorjs/tarball/master'
  homepage 'https://github.com/mozilla/doctorjs'
  md5 '978320b9506310eef930a0d9187ab42f'
  version '0.1'
  depends_on 'node'

  def install
    system "make install"
  end
end
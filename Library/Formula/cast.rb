require 'formula'

class Cast < Formula
  url 'http://files.cast-project.org/cast-0.2.0.tar.gz'
  homepage 'http://cast-project.org'
  md5 'b6a4f2b1126e969ee1696f50471c7345'

  depends_on 'scons' => :build
  depends_on 'runit'

  def install
    system "scons", "install", "CASTPREFIX=#{prefix}"
  end
end

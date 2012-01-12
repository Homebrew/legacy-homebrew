require 'formula'

class Swfmill < Formula
  # Staying on 3.0 until this 3.1 issue is fixed:
  # https://bugs.launchpad.net/swfmill/+bug/611403
  url 'http://swfmill.org/releases/swfmill-0.3.0.tar.gz'
  homepage 'http://swfmill.org'
  md5 'b7850211cf683aa7a1c62324b56e3216'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

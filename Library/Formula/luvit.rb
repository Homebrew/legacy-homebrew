require 'formula'

class Luvit < Formula
  homepage 'http://luvit.io'
  url 'http://luvit.io/dist/latest/luvit-0.7.0.tar.gz'
  sha1 '6b6ca9723e90473df15abc92cbcb12cfdf7529ab'

  head 'https://github.com/luvit/luvit.git'

  depends_on 'pkg-config' => :build
  depends_on 'luajit'

  def install
    ENV['USE_SYSTEM_SSL'] = '1'
    ENV['USE_SYSTEM_LUAJIT'] = '1'
    ENV['PREFIX'] = prefix
    system 'make'
    system 'make', 'install'
  end
end

require 'formula'

class Luvit < Formula
  homepage 'http://luvit.io'
  url 'http://luvit.io/dist/latest/luvit-0.8.2.tar.gz'
  sha1 '0e53fa128eb48d429134435f15653c80b8c9485c'

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

require 'formula'

class Luvit < Formula
  homepage 'http://luvit.io'
  url 'http://luvit.io/dist/latest/luvit-0.6.1.tar.gz'
  sha1 'f5e49a33e0e32d8e75d5cdd843d54f213f6e508e'

  head 'https://github.com/luvit/luvit.git'

  def install
    ENV['PREFIX'] = prefix
    system './configure'
    system 'make'
    system 'make', 'install'
  end
end

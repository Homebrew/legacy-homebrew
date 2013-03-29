require 'formula'

class F3 < Formula
  homepage 'http://oss.digirati.com.br/f3/'
  url 'https://github.com/AltraMayor/f3/archive/v2.1.tar.gz'
  sha1 '0e0f93e96f1d9c89227fcac1e5f80d5696d7c315'

  def install
    system "make mac"
    bin.install 'f3read', 'f3write'
  end
end

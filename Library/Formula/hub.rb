require 'formula'

class Hub < Formula
  url 'https://github.com/defunkt/hub/tarball/v1.8.2'
  homepage 'https://github.com/defunkt/hub#readme'
  head 'https://github.com/defunkt/hub.git'
  md5 '10924032b54b9ae9ed1b42c22bfecd3f'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/tarball/v1.3.2'
  homepage 'http://github.com/defunkt/hub'
  md5 '2b7b253a7ee6cba126d9965834b3aa70'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

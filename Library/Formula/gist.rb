require 'formula'

class Gist <Formula
  url 'http://github.com/defunkt/gist/tarball/v1.0.3'
  homepage 'http://github.com/defunkt/gist'
  md5 'e0b9eb913c46ad49e5d6072c420b2a17'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

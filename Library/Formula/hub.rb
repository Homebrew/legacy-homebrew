require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/tarball/v1.0.2'
  homepage 'http://github.com/defunkt/hub'
  md5 '4e31316783e53ba200580d6557bb9314'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

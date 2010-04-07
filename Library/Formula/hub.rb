require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/raw/gh-pages/standalone'
  homepage 'http://github.com/defunkt/hub'
  version '1.1.0'
  md5 '4f5e4dec0663fb33aa3e8e46edbfce5a'

  def install
    bin.install 'standalone' => 'hub'
  end
end

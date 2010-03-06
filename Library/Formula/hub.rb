require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/tarball/v1.0.1'
  homepage 'http://github.com/defunkt/hub'
  md5 'c838f7419173cc646a5b355307c5c1c7'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

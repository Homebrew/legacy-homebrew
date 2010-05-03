require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/tarball/v1.3.1'
  homepage 'http://github.com/defunkt/hub'
  version '1.3.1'
  md5 'e55dc72fa5508377c1259a231d19a554'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

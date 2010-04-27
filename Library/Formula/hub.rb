require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/tarball/v1.2.0'
  homepage 'http://github.com/defunkt/hub'
  version '1.2.0'
  md5 'df572f6f89722adf241fd6feecebc32c'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

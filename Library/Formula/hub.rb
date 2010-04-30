require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/tarball/v1.3.1'
  homepage 'http://github.com/defunkt/hub'
  version '1.3.1'
  md5 'a9d8d8e6d0c5bccb6c06b1482e3bdcca'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

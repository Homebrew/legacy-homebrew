require 'formula'

class Hub <Formula
  url 'http://github.com/defunkt/hub/tarball/v0.3.0'
  homepage 'http://github.com/defunkt/hub'
  md5 'f77c39cc69c5e9e909608a7580b0feaf'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

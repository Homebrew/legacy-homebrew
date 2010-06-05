require 'formula'

class Gist <Formula
  url 'http://github.com/defunkt/gist/tarball/v1.1.1'
  homepage 'http://github.com/defunkt/gist'
  md5 'a1288387245cee6b1605d6756a2dac3b'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

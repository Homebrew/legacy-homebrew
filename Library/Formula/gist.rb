require 'formula'

class Gist <Formula
  url 'http://github.com/defunkt/gist/tarball/v1.0.1'
  homepage 'http://github.com/defunkt/gist'
  md5 'b1ee3a40dfe3c4fff2a98f2c525cb64a'

  depends_on 'mg' => :ruby

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

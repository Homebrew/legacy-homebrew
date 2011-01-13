require 'formula'

class Hub <Formula
  url 'https://github.com/defunkt/hub/tarball/v1.5.0'
  homepage 'https://github.com/defunkt/hub'
  md5 '3e719ea33cd2b78795dbfc6f8c5e41f8'

  def install
    system "rake", "install", "prefix=#{prefix}"
  end
end

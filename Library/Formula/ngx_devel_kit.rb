require 'formula'

class NgxDevelKit < Formula
  homepage 'https://github.com/simpl/ngx_devel_kit'
  url 'https://github.com/simpl/ngx_devel_kit/archive/v0.2.18.tar.gz'
  sha1 'e21ba642f26047661ada678b21eef001ee2121d8'

  def install
    prefix.install Dir['*']
  end

end

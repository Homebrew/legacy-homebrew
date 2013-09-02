require 'formula'

class Ngrok < Formula
  homepage 'https://ngrok.com/'
  url 'https://dl.ngrok.com/darwin_amd64/ngrok.zip'
  sha1 '802cf678b3efaacc95e8cdbb162bb7c49e3f6cc2'
  version '0.21'

  def install
    bin.install 'ngrok'
  end
end

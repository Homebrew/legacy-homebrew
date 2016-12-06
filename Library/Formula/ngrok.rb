require 'formula'

class Ngrok < Formula
  homepage 'https://ngrok.com'
  url 'https://dl.ngrok.com/darwin_386/0.11/ngrok.zip'
  sha1 'd53783814d9d6bcd758710389bfe5c6511097f30'
  head 'https://dl.ngrok.com/darwin_386/ngrok.zip'

  def install
    bin.install ["ngrok"]
  end

  test do
    system "ngrok -version"
  end
end

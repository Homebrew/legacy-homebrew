require 'formula'

class Ngrok < Formula
  homepage 'https://github.com/inconshreveable/ngrok'
  url 'https://dl.ngrok.com/darwin_amd64/ngrok.zip'
  version '0.17'  
  sha1 '802cf678b3efaacc95e8cdbb162bb7c49e3f6cc2'

  def install
    bin.install 'ngrok'
  end

  def caveats; <<-EOS.undent
    Visit https://ngrok.com/signup to create an account.
    
    You must specify your auth token when you use ngrok to identify your account.
    You only need to do this the first time. ngrok saves your auth token in ~/.ngrok
    so you don't have to repeat this step in the future on the same computer.

    ngrok -authtoken [AUTH_TOKEN] [LOCAL PORT]
    EOS
  end

  test do
   system "#{bin}/ngrok"
  end
end

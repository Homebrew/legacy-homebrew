require 'formula'

class Gifify < Formula
  homepage 'https://github.com/jclem/gifify'
  url 'https://github.com/jclem/gifify/archive/9be704a8b4547731c892fc536423b871e025665f.tar.gz'
  version '9be704a8b4547731c892fc536423b871e025665f'
  sha1 '0fb7b61b348a0d73afa87c87f18f56ec15f89d93'

  head 'https://github.com/jclem/gifify.git'

  depends_on 'ffmpeg'
  depends_on 'imagemagick'

  def install
    bin.install 'gifify.sh' => 'gifify'
  end

  def caveats; <<-EOS.undent
    To allow uploading to CloudApp, run:
      gem install cloudapp
    EOS
  end
end

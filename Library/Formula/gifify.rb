require 'formula'

class Gifify < Formula
  homepage 'https://github.com/jclem/gifify'
  url 'https://github.com/jclem/gifify/archive/v1.0.tar.gz'
  sha1 '7179e5738db1be9030523e6db5144ba7f5f42d84'

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

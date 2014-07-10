require 'formula'

class Mkvdts2ac3 < Formula
  homepage 'https://github.com/JakeWharton/mkvdts2ac3'
  head 'https://github.com/JakeWharton/mkvdts2ac3.git'

  url 'https://github.com/JakeWharton/mkvdts2ac3/archive/1.6.0.tar.gz'
  sha1 'e427eb6875d935dc228c42e99c3cd19c7ceaa322'

  depends_on 'mkvtoolnix'
  depends_on 'ffmpeg'

  def install
    bin.install "mkvdts2ac3.sh" => "mkvdts2ac3"
  end
end

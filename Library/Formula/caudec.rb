require 'formula'

class Caudec < Formula
  homepage 'http://caudec.net'
  url 'http://caudec.net/downloads/caudec-1.7.5.tar.gz'
  sha1 'e3b8ccdb976e02f82be07041a624d1f0cdd005d4'
  bottle do
    sha1 "e225732d654439421126d0c4192a0a778dc5c031" => :yosemite
    sha1 "5005b2e4daf1ffd2f5e84eddb79b8f427f918baf" => :mavericks
    sha1 "a611215d98ffc01584055b84866e4bee949bfb02" => :mountain_lion
  end

  revision 1

  depends_on 'gnu-sed'
  depends_on 'shntool'
  depends_on 'aacgain' => :optional
  depends_on 'alac' => :optional
  depends_on 'cksfv' => :optional
  depends_on 'coreutils' => :optional
  depends_on 'eye-d3' => :optional
  depends_on 'ffmpeg' => :optional
  depends_on 'flac' => :optional
  depends_on 'flake' => :optional
  depends_on 'lame' => :optional
  depends_on 'mp3gain' => :optional
  depends_on 'musepack' => :optional
  depends_on 'opus' => :optional
  depends_on 'sox' => :optional
  depends_on 'vorbis-tools' => :optional
  depends_on 'vorbisgain' => :optional
  depends_on 'wavpack' => :optional
  depends_on 'wget' => :optional

  def install
    bin.install 'caudec'
    (bin/'decaude').make_symlink bin/'caudec'
    etc.install 'caudecrc'
  end

  def caveats; <<-EOS.undent
    You can find an up-to-date caudecrc file in
    #{HOMEBREW_PREFIX}/etc

    Copy it to ~/.caudecrc ('.caudecrc' in your home directory),
    or update your existing copy as needed.

    EOS
  end
end

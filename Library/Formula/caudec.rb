require 'formula'

class Caudec < Formula
  homepage 'http://caudec.outpost.fr/'
  url 'http://caudec.outpost.fr/downloads/caudec-1.6.4.tar.gz'
  sha1 '4c4ad207e86c8f8bf15545bab1c434525cd79f7d'
  bottle do
    sha1 "4fcd8647ac1bcd81911f437e6a6fa2d2bc1a6c6a" => :mavericks
    sha1 "ff95a111531d9dcc88b51a713543ca03df7605f6" => :mountain_lion
    sha1 "c33863b2e29bf5433039dfb187a1b91bc448305b" => :lion
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

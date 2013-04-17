require 'formula'

class Caudec < Formula
  homepage 'http://caudec.outpost.fr/'
  url 'http://caudec.outpost.fr/downloads/caudec-1.6.3.tar.gz'
  sha1 '1bb477d63a956caae5f7ef97f039dd37420ddb55'

  depends_on 'gnu-sed'
  depends_on 'shntool'
  depends_on 'gnutls' => :optional
  depends_on 'flac' => :optional
  depends_on 'flake' => :optional
  depends_on 'wavpack' => :optional
  depends_on 'alac' => :optional
  depends_on 'ffmpeg' => :optional
  depends_on 'lame' => :optional
  depends_on 'vorbis-tools' => :optional
  depends_on 'musepack' => :optional
  depends_on 'opus' => :optional
  depends_on 'vorbisgain' => :optional
  depends_on 'mp3gain' => :optional
  depends_on 'aacgain' => :optional
  depends_on 'sox' => :optional
  depends_on 'wget' => :optional
  depends_on 'cksfv' => :optional
  depends_on 'eye-d3' => :optional

  def install
    bin.install('caudec')
    system "ln -s caudec #{bin}/decaude"
    system "mkdir #{share}"
    system "mkdir #{share}/doc"
    system "mv caudecrc #{share}/doc/"
    opoo "You can find an up-to-date caudecrc file in"
    opoo "#{share}/doc/"
    opoo "Copy it to ~/.caudecrc ('.caudecrc' in your home directory),"
    opoo "or update your existing copy as needed."
  end
end

require 'formula'

class Handbrake < Formula
  url 'http://downloads.sourceforge.net/handbrake/HandBrake-0.9.5.tar.bz2'
  homepage 'http://handbrake.fr/'
  md5 'e17d3663fc36a985fe43e188695e3196'

  depends_on 'yasm'
  # In theory, Handbrake depends on loads of other things. In practice, it
  # downloads them itself, no matter what I do.

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-xcode"

    # Run make within the build directory
    Dir.chdir "build"
    system "make"
    bin.install 'HandbrakeCLI'
  end
end

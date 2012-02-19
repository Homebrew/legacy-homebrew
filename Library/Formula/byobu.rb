require 'formula'

class Byobu < Formula
  url 'http://launchpad.net/byobu/trunk/4.51/+download/byobu_4.51.orig.tar.gz'
  homepage 'http://launchpad.net/byobu'
  md5 '4786cbff4149f3eb9b8815474a63af2e'
  depends_on 'gnu-sed'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    version_match = '##VERSION_NUMBER##'
    prefix_match = prefix.sub(version, version_match)

    <<-EOS.undent
    You will need to set BYOBU_PREFIX to Homebrew's install path before 
    running byobu.

    Something like:

      echo 'export BYOBU_PREFIX=`brew --prefix`' >> $HOME/.profile

    If upgrading from 4.30 or earlier, you may need to tweak the files in your 
    $HOME/.byobu directory to remove hardcoded references to this 
    formula's prefix.

    Something like, replacing #{version_match} with your previously installed 
    version number before running:

      find $HOME/.byobu -type f -print0 | \\
        xargs -0 sed -e 's@#{prefix_match}@#{HOMEBREW_PREFIX}@g' -i ''

    EOS
  end
end

require 'formula'

class Jmxtrans < Formula
  homepage 'https://github.com/jmxtrans/jmxtrans'
  url 'https://github.com/downloads/jmxtrans/jmxtrans/jmxtrans-20121016-151320-36564abc7e.zip'
  version '20121016'
  sha1 '2b2dc4727de16a30e8b7ac84b9bb4cb7b1ea4a6f'

  def install
    prefix.install_metafiles
    libexec.install Dir['*']
    (libexec/'jmxtrans.sh').chmod 0755
    bin.install_symlink libexec/'jmxtrans.sh' => "jmxtrans"
  end
end

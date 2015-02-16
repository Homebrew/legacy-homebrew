require 'formula'

class Byobu < Formula
  homepage 'http://byobu.co'
  url 'https://launchpad.net/byobu/trunk/5.90/+download/byobu_5.90.orig.tar.gz'
  sha1 'eea1d07673bc62ac1f5464111106fffd4bc22230'

  bottle do
    sha1 "26ae7ad8f711402f1f203353723e30531a4a3e71" => :yosemite
    sha1 "73239a933c04b230527b4164fc009090c0782007" => :mavericks
    sha1 "1da7ebe7174704d91b39cfb15f1d88290a5c876e" => :mountain_lion
  end

  depends_on 'coreutils'
  depends_on 'gnu-sed' # fails with BSD sed
  depends_on 'tmux'
  depends_on 'newt' => 'with-python'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end
end

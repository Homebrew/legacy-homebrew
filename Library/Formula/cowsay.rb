require 'formula'

class Cowsay < Formula
  homepage 'http://www.nog.net/~tony/warez/cowsay.shtml'
  url 'http://ftp.acc.umu.se/mirror/cdimage/snapshot/Debian/pool/main/c/cowsay/cowsay_3.03.orig.tar.gz'
  sha1 'cc65a9b13295c87df94a58caa8a9176ce5ec4a27'

  # Official download is 404:
  # url 'http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz'

  def install
    system "/bin/sh", "install.sh", prefix
    mv prefix/'man', share
  end

  test do
    output = `#{bin}/cowsay moo`
    assert output.include?("moo")  # bubble
    assert output.include?("^__^") # cow
    assert_equal 0, $?.exitstatus
  end
end

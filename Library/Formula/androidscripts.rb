require "formula"

class Androidscripts < Formula

  homepage 'https://github.com/dhelleberg/android-scripts'
  url 'https://github.com/dhelleberg/android-scripts/archive/0.9.0.tar.gz'
  sha1 '29cbf630df0658f053b787a03ef209b617a1db20'
  head 'https://github.com/dhelleberg/android-scripts.git'

  depends_on "groovy"

  def install
    bin.install 'src/devtools.groovy' => 'devtools'
    bin.install 'src/adbwifi.groovy' => 'adbwifi'
  end

  test do
    output = `#{bin}/devtools --help`.strip
    assert_match /^usage: devtools/, output
  end
end
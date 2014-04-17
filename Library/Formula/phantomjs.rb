require "formula"

class Phantomjs < Formula
  homepage "http://www.phantomjs.org/"
  url "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-source.zip"
  sha1 "124b017d493d5ccabd22afaf078d0650ac048840"

  bottle do
    cellar :any
    sha1 "fb82891b5d63de81a89c7b5b41b8aeba39dec470" => :mavericks
    sha1 "042dd2341a1140cdcd575e08aa432ed659e3f00e" => :mountain_lion
    sha1 "575af708d7e5ef6e39e90766ffd2bf97b6c4b51b" => :lion
  end

  patch do
    url "https://github.com/ariya/phantomjs/commit/fe6a96.diff"
    sha1 "d3efd38e0f3f0da08530d0bf603ea72ebdf06b78"
  end

  def install
    inreplace 'src/qt/preconfig.sh', '-arch x86', '-arch x86_64' if MacOS.prefer_64_bit?
    args = ['--confirm', '--qt-config']
    # we have to disable these to avoid triggering Qt optimization code
    # that will fail in superenv (in --env=std, Qt seems aware of this)
    args << '-no-3dnow -no-ssse3' if superenv?
    system './build.sh', *args
    bin.install 'bin/phantomjs'
    (share+'phantomjs').install 'examples'
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      console.log('hello');
      phantom.exit();
    EOS

    output = `#{bin}/phantomjs #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end

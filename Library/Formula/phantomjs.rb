require 'formula'

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.6-source.zip'
  sha1 '515844971dc4ffce54241f750ada52f537b34160'

  bottle do
    cellar :any
    revision 4
    sha1 "b6b4fd6cc542cd5445474156599286126a82c146" => :mavericks
    sha1 "a2e90490e3e0f9b9d4aa969a87be8efc801b6853" => :mountain_lion
    sha1 "933e15b3b70fcc19f9bd08e77a3a2ed8cef2bf64" => :lion
  end

  def patches
    [
      'https://github.com/ariya/phantomjs/commit/fe6a96.patch',
      'https://github.com/ariya/phantomjs/commit/b1cfe1.patch',
    ]
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
end

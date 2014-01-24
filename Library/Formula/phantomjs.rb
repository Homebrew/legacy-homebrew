require 'formula'

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.6-source.zip'
  sha1 '515844971dc4ffce54241f750ada52f537b34160'

  bottle do
    cellar :any
    sha1 "43718bd97637d1c771001c332b841cbe370ead45" => :mavericks
    sha1 "a7099dc37cc859ca6e2bcf401b849174bc5cc59b" => :mountain_lion
    sha1 "ae814f40a04f7199bd76de1ed0789c45d6b28495" => :lion
  end

  def patches
    [
      'https://github.com/ariya/phantomjs/commit/fe6a96.patch',
      'https://github.com/mikemcquaid/phantomjs/commit/50e046.patch',
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

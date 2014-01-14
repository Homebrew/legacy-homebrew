require 'formula'

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'https://phantomjs.googlecode.com/files/phantomjs-1.9.2-source.zip'
  sha1 '08559acdbbe04e963632bc35e94c1a9a082b6da1'

  bottle do
    cellar :any
    revision 3
    sha1 'eb1a54dc4a5e13f9fe83f83fc82c8b3429ff28eb' => :mavericks
    sha1 'f80e0ff497dafba134a1a29356aa7a4e5192ef6d' => :mountain_lion
    sha1 '07aefd1baff3a3a63e9d6a1385fe9e83f63eedba' => :lion
  end

  def patches
    [
      'https://github.com/ariya/phantomjs/commit/fe6a96.patch',
      'https://github.com/ariya/phantomjs/commit/b67866.patch',
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

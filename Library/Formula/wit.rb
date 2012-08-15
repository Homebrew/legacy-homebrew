require 'formula'

class Wit <Formula
  url 'http://wit.wiimm.de/download/wit-v2.07a-r3955-mac.tar.gz'
  sha1 '46ec45454cc880bd61225bf609d00fa26eba906e'
  version '2.07a'
  homepage 'http://wit.wiimm.de/'

  def install
    bin.install 'bin/wdf'
    bin.install 'bin/wdf-cat'
    bin.install 'bin/wdf-dump'
    bin.install 'bin/wfuse'
    bin.install 'bin/wit'
    bin.install 'bin/wwt'
    FileUtils.mv 'share', 'wit'
    share.install 'wit'
  end
end

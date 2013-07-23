require 'formula'

# Use the official github mirror, it is easier to find tags there
# .even versions are stable, .odd releases are devel. Kind of:
# https://code.google.com/p/v8/issues/detail?id=2545
# http://omahaproxy.appspot.com/

class V8 < Formula
  homepage 'http://code.google.com/p/v8/'
  url 'https://github.com/v8/v8/archive/3.20.7.tar.gz'
  sha1 '3d7cbebcd1b953f07d87d6111377aeff4ebda1fa'

  head 'https://github.com/v8/v8.git'

  option 'with-readline', 'Use readline instead of libedit'

  # gyp currently depends on a full xcode install
  # https://code.google.com/p/gyp/issues/detail?id=292
  depends_on :xcode
  depends_on 'readline' => :optional

  def install
    system 'make dependencies'
    system 'make', 'native',
                   "-j#{ENV.make_jobs}",
                   "library=shared",
                   "snapshot=on",
                   "console=readline"

    prefix.install 'include'
    cd 'out/native' do
      lib.install Dir['lib*']
      bin.install 'd8', 'lineprocessor', 'preparser', 'process', 'shell' => 'v8'
      bin.install Dir['mksnapshot.*']
    end
  end
end

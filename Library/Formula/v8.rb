require 'formula'

# When trunk is 3.x, then 3.x is devel and 3.(x-1)
# is stable.
# https://code.google.com/p/v8/issues/detail?id=2545
# http://omahaproxy.appspot.com/

class V8 < Formula
  homepage 'http://code.google.com/p/v8/'
  head 'https://github.com/v8/v8.git'
  url 'https://github.com/v8/v8/archive/3.20.17.tar.gz'
  sha1 '86c61558a0e6fc64f6a4997d16d8077c2d50d98f'

  devel do
    url 'https://github.com/v8/v8/archive/3.21.15.tar.gz'
    sha1 'd2b1233f58181c9d3a08861bb7fd21f34e8870d1'
  end

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

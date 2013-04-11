require 'formula'

class V8 < Formula
  homepage 'http://code.google.com/p/v8/'
  # Use the official github mirror, it is easier to find tags there
  url 'https://github.com/v8/v8/archive/3.17.15.tar.gz'
  sha1 '611fa265cdaae74b00556de6576c07c4dcfb3efe'

  head 'https://github.com/v8/v8.git'

  # gyp currently depends on a full xcode install
  # https://code.google.com/p/gyp/issues/detail?id=292
  depends_on :xcode

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
      bin.install 'd8', 'lineprocessor', 'mksnapshot', 'preparser', 'process', 'shell' => 'v8'
    end
  end
end

require 'formula'

# When trunk is 3.x, then 3.x is devel and 3.(x-1)
# is stable.
# https://code.google.com/p/v8/issues/detail?id=2545
# http://omahaproxy.appspot.com/

class V8 < Formula
  homepage 'http://code.google.com/p/v8/'
  url 'https://github.com/v8/v8/archive/3.19.18.4.tar.gz'
  sha1 'f44c8eed0fe93b2d04d1d547a1e2640f41161354'

  devel do
    url 'https://github.com/v8/v8/archive/3.20.11.1.tar.gz'
    sha1 '620ff5aed665b448f1d18a698e016735c57c55cc'
  end

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

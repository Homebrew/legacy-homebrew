require 'formula'

class V8 < Formula
  head 'https://github.com/v8/v8.git', :using => :git
  url 'https://github.com/v8/v8/tarball/3.7.0'
  homepage 'http://code.google.com/p/v8/'
  sha1 "8b22460558b39d0016cf372b08112f3636a08f25"

  depends_on 'scons' => :build

  def install
    arch = Hardware.is_64_bit? ? 'x64' : 'ia32'

    system "scons", "-j #{ENV.make_jobs}",
                    "arch=#{arch}",
                    "mode=release",
                    "snapshot=on",
                    "library=shared",
                    "visibility=default",
                    "console=readline",
                    "sample=shell"

    include.install Dir['include/*']
    lib.install Dir['libv8.*']
    bin.install 'shell' => 'v8'

    system "install_name_tool -change libv8.dylib #{lib}/libv8.dylib #{bin}/v8"
  end
end

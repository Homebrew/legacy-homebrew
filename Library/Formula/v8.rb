require 'formula'

class V8 < Formula
  homepage 'http://code.google.com/p/v8/'
  # Use the official github mirror, it is easier to find tags there
  url 'https://github.com/v8/v8/tarball/3.9.24'
  sha1 '111bf871bda84e72fdf93f2877d97591b918db2a'

  head 'https://github.com/v8/v8.git'

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

    prefix.install 'include'
    lib.install 'libv8.dylib'
    bin.install 'shell' => 'v8'

    system "install_name_tool", "-change", "libv8.dylib", "#{lib}/libv8.dylib", "#{bin}/v8"
  end
end

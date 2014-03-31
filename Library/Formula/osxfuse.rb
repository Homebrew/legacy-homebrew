require 'formula'

class Osxfuse < Formula
  homepage 'http://osxfuse.github.io'
  url 'https://github.com/osxfuse/osxfuse.git', :tag => 'osxfuse-2.6.3'

  head 'https://github.com/osxfuse/osxfuse.git', :branch => 'osxfuse-2'

  bottle do
    sha1 "e3433b2a5dbb7d72db1fb170635f735827a57335" => :mavericks
    sha1 "6e4985fd096245ac35c60fcd54e31845a3f6dbaa" => :mountain_lion
    sha1 "7284e1a0da8d85c40c35bf7a066a7a4bfb939d39" => :lion
  end

  depends_on :macos => :snow_leopard
  depends_on :xcode
  depends_on :autoconf
  depends_on :automake
  depends_on 'gettext' => :build
  depends_on 'libtool' => :build

  conflicts_with 'fuse4x', :because => 'both install `fuse.pc`'

  def install
    # Do not override Xcode build settings
    ENV.remove_cc_etc

    if MacOS::Xcode.provides_autotools?
      # Xcode version of aclocal does not respect ACLOCAL_PATH
      ENV['ACLOCAL'] = 'aclocal ' + ENV['ACLOCAL_PATH'].split(':').map {|p| '-I' + p}.join(' ')
    end

    system "./build.sh", "-t", "homebrew", "-f", prefix
  end

  def caveats; <<-EOS.undent
    If upgrading from a previous version of osxfuse, the previous kernel extension
    will need to be unloaded before installing the new version. First, check that
    no FUSE-based file systems are running:

      mount -t osxfusefs

    Unmount all FUSE file systems and then unload the kernel extension:

      sudo kextunload -b com.github.osxfuse.filesystems.osxfusefs

    The new osxfuse file system bundle needs to be installed by the root user:

      sudo /bin/cp -RfX #{prefix}/Library/Filesystems/osxfusefs.fs /Library/Filesystems
      sudo chmod +s /Library/Filesystems/osxfusefs.fs/Support/load_osxfusefs
    EOS
  end
end

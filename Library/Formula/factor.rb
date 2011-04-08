require 'formula'

# This formula installs Factor TRUNK.
# One can install the latest stable release using the official DMG.

class Factor < Formula
  head 'git://github.com/slavapestov/factor.git'
  homepage 'http://factorcode.org/'

  def install
    # The build script assumes it is in a Git repository.
    ENV['GIT_DIR']="#{@downloader.cached_location}/.git"
    system "./build-support/factor.sh update"

    prefix.install ["Factor.app", "factor.image", "factor"]
    (bin/'factor').write <<-EOS.undent
    #!/bin/sh
    exec #{prefix}/factor $@
    EOS
  end

  def caveats; <<-EOS.undent
    Cocoa app installed to #{prefix}/Factor.app.
    Makes use of 'factor.image' in the same folder.
    EOS
  end
end

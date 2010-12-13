require 'formula'

# This formula installs Factor TRUNK.
# One can install the latest stable release using the official DMG.

class Factor <Formula
  head 'git://github.com/slavapestov/factor.git'
  homepage 'http://factorcode.org/'

  def install
    # The build script assume it's in a Git repository.
    ENV['GIT_DIR']="#{@downloader.cached_location}/.git"
    system "./build-support/factor.sh update"

    libexec.install ["Factor.app", "factor.image", "factor"]
    (bin/'factor').write <<-EOS.undent
    #!/bin/sh
    exec #{libexec}/factor $@
    EOS
  end

  def caveats
    "Cocoa app installed to #{libexec}/Factor.app.\n\n"\
    "Makes use of 'factor.image' in the same folder."
  end
end

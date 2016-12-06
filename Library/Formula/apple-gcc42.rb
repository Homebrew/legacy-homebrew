require 'formula'

class PkgDownloadStrategy < CurlDownloadStrategy
  def stage
    # The compilers are distributed as a OS X 10.5 package- a single flat xar
    # archive instead of a bundle.
    safe_system '/usr/bin/xar', '-xf', @tarball_path
    chdir

    # Clean up.
    safe_system "mv *.pkg/Payload Payload.gz"
    safe_system "ls | grep -v Payload | xargs rm -r"
  end
end

class AppleGcc42 < Formula
  homepage 'http://r.research.att.com/tools/'
  url 'http://r.research.att.com/tools/gcc-42-5666.3-darwin11.pkg'
  md5 '3ccf46da27aaba17706b420711fb997e'
  version '4.2.1-5666.3'


  def download_strategy
    PkgDownloadStrategy
  end

  # Don't strip compiler binaries.
  skip_clean :all

  def install
    unless MacOS.xcode_version >= "4.2"
      onoe <<-EOS.undent
        The compilers provided by this formula are designed for use only with
        versions of Xcode which do not include them.
      EOS
      exit 1
    end

    safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"

    # don't install gfortran compilers, just gcc
    require 'find'
    Find.find(prefix) {|child| rm child if child.to_s =~ /gfortran/}
  end

  def caveats
    <<-EOS.undent
      NOTE:
      This formula provides components that were removed from XCode in the 4.2
      release.

      This formula contains compilers built from Apple's GCC sources, build
      5666.3, available from:

        http://opensource.apple.com/tarballs/gcc

      All compilers have a `-4.2` suffix.
    EOS
  end
end

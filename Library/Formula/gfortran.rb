require 'formula'
require 'brew.h'

class GfortranPkgDownloadStrategy <CurlDownloadStrategy
  def stage
    # The 4.2.4 compiler is distributed as a OS X 10.5
    # package- a single flat xar archive instead of a
    # bundle.
    safe_system "/usr/bin/xar -xf #{@tarball_path}"
    chdir

    # Clean up.
    safe_system "mv *.pkg/Payload Payload.gz"
    safe_system "ls | grep -v Payload | xargs rm -r"
  end
end

class Gfortran <Formula
  if MACOS_VERSION < 10.6
    # Leopard
    url 'http://r.research.att.com/gfortran-42-5577.pkg'
    md5 '30fb495c93cf514003cdfcb7846dc701'
    version "4.2.4-5577"
  else
    # Snow Leopard
    case gcc_42_build
    when 5659
      url 'http://r.research.att.com/gfortran-42-5659.pkg'
      md5 '71bd546baa45c9c0fb4943cdd72ee274'
      version "4.2.4-5659"
    else
      # These links should be updated to point to gfortran
      # binaries for XCode build 5664 when they appear.
      url 'http://r.research.att.com/gfortran-42-5659.pkg'
      md5 '71bd546baa45c9c0fb4943cdd72ee274'
      version "4.2.4-5659"
    end
  end

  homepage 'http://r.research.att.com/tools/'

  def download_strategy
    GfortranPkgDownloadStrategy
  end

  # Shouldn't strip compiler binaries.
  skip_clean [ 'bin', 'lib', 'libexec' ]

  def install
    # The version of pax jumped 16 years in development between OS X 10.5
    # and OS X 10.6. In that time it became security concious. Additionally,
    # there are some slight variations in the packaging- because of this
    # installation is broken down by XCode version.
    case gcc_42_build
    when 5577
      ohai "Installing gfortran 4.2.4 for XCode 3.1.4 (build 5577)"
      safe_system "pax -rz -f Payload.gz -s ',./usr,#{prefix},'"
      # The 5577 package does not contain the gfortran->gfortran-4.2 symlink
      safe_system "ln -sf #{bin}/gfortran-4.2 #{bin}/gfortran"
      safe_system "ln -sf #{man1}/gfortran-4.2.1 #{man1}/gfortran.1"
    when 5659
      ohai "Installing gfortran 4.2.4 for XCode 3.2.2 (build 5659)"
      safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"
      safe_system "ln -sf #{man1}/gfortran-4.2.1 #{man1}/gfortran.1"
    when 5664
      # This section should be updated when binaries for 5664 appear.
      ohai "Installing gfortran 4.2.4 for XCode 3.2.2 (build 5659)"
      safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"
      safe_system "ln -sf #{man1}/gfortran-4.2.1 #{man1}/gfortran.1"
    else
      onoe <<-EOS.undent
        Currently the gfortran compiler provided by this brew is only supported
        for XCode 3.1.4 on OS X 10.5.x and XCode 3.2.2/3.2.3 on OS X 10.6.x
      EOS
    end
  end

  def caveats
    caveats = <<-EOS
Fortran compiler support in brews is currently experimental.  One of the
consequences of this is that Homebrew does not set environment flags to ensure
that a particular Fortran compiler is used and that the resulting code is
optimized properly.  Therefore, in addition to using:

    depends_on "gfortran"

Fortran-based brews should also specify environment variables for the Fortran
compiler in the install section:

    # Select the Fortran compiler to be used:
    ENV["FC"] = ENV["F77"] "\#{HOMEBREW_PREFIX}/bin/gfortran"

    # Set Fortran optimization flags:
    ENV["FFLAGS"] = ENV["FCFLAGS"] = ENV["CFLAGS"]

Following these guidelines will allow Fortran-based brews to be easily edited so
that alternate Fortran compilers, such as ifort, can be used instead of the
version of gfortran provided by Homebrew.
    EOS
  end
end

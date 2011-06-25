require 'formula'

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

class Gfortran < Formula
  if MacOS.leopard?
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
      url 'http://r.research.att.com/gfortran-42-5664.pkg'
      md5 'eb64ba9f8507da22e582814a69fbb7ca'
      version "4.2.4-5664"
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
      ohai "Installing gfortran 4.2.4 for XCode 3.2.3 (build 5664)"
      safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"
      safe_system "ln -sf #{man1}/gfortran-4.2.1 #{man1}/gfortran.1"
    when 5666
      ohai "Installing gfortran 4.2.4 for XCode 4.0 (build 5666)"
      safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"
      safe_system "ln -sf #{man1}/gfortran-4.2.1 #{man1}/gfortran.1"
    else
      onoe <<-EOS.undent
        Currently the gfortran compiler provided by this brew is only supported
        for XCode 3.1.4 on OS X 10.5.x and XCode 3.2.2/3.2.3 on OS X 10.6.x

        Software update can help upgrade your copy of XCode.  The latest version
        of XCode is also available from:

            http://developer.apple.com/technologies/xcode.html
      EOS
    end
  end

  def caveats; <<-EOS.undent
    Brews that require a Fortran compiler should not use:
      depends_on 'gfortran'

    The preferred method of declaring Fortran support is to use:
      def install
        ...
        ENV.fortran
        ...
      end

      EOS
  end
end

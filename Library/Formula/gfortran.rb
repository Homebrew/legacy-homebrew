require 'formula'

class GfortranPkgDownloadStrategy < CurlDownloadStrategy
  def stage
    # The 4.2.4 compiler is distributed as a OS X 10.5
    # package- a single flat xar archive instead of a
    # bundle.
    safe_system '/usr/bin/xar', '-xf', @tarball_path
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
  elsif MACOS_VERSION == 10.6
    # Snow Leopard
    case gcc_42_build
    when 5659
      url 'http://r.research.att.com/gfortran-42-5659.pkg'
      md5 '71bd546baa45c9c0fb4943cdd72ee274'
      version "4.2.4-5659"
    else
      # This version works for XCode 3.2.3-4.0 on Snow Leopard.
      url 'http://r.research.att.com/gfortran-42-5664.pkg'
      md5 'eb64ba9f8507da22e582814a69fbb7ca'
      version "4.2.4-5664"
    end
  else
    # Lion
    if MacOS.xcode_version >= '4.2'
      # This version contains an entire Apple-GCC 4.2 (i386/x86_64) build for
      # Lion. After installation, we will remove all compilers other than
      # GFortran.
      url 'http://r.research.att.com/tools/gcc-42-5666.3-darwin11.pkg'
      md5 '3ccf46da27aaba17706b420711fb997e'
      version '4.2.4-5666.3'
    else
      url 'http://r.research.att.com/gfortran-lion-5666-3.pkg'
      md5 '7eb140822c89bec17db5666859868b3b'
      version "4.2.4-5666.3"
    end
  end

  # For more information about GFortran, see:
  #
  #     http://gcc.gnu.org/wiki/GFortran
  #
  # The homepage points to r.research.att.com because this site contains
  # specific information about the binary distribution that we use.
  homepage 'http://r.research.att.com/tools/'

  def download_strategy
    GfortranPkgDownloadStrategy
  end

  # Shouldn't strip compiler binaries.
  skip_clean :all

  def install
    if MacOS.xcode_version >= '4.2' and MACOS_VERSION >= 10.7
      ohai "Installing gfortran 4.2.4 for XCode 4.2 (build 5666) or higher"
      safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"

      # This package installs a whole GCC suite. Remove non-fortran
      # components.
      bin.children.reject{|p| p.basename.to_s.match /gfortran/}.each{|p| rm p}
      man1.children.reject{|p| p.basename.to_s.match /gfortran/}.each{|p| rm p}
      (include + 'gcc').rmtree

      # This package does not contain the gfortran->gfortran-4.2 symlink
      safe_system "ln -sf #{bin}/gfortran-4.2 #{bin}/gfortran"
    else
      # Break installation down by GCC build as there are some slight
      # variations in packaging.
      case gcc_42_build
      when 5577
        ohai "Installing gfortran 4.2.4 for XCode 3.1.4 (build 5577)"
        safe_system "pax -rz -f Payload.gz -s ',./usr,#{prefix},'"
        # The 5577 package does not contain the gfortran->gfortran-4.2 symlink
        safe_system "ln -sf #{bin}/gfortran-4.2 #{bin}/gfortran"
      when 5659
        ohai "Installing gfortran 4.2.4 for XCode 3.2.2 (build 5659)"
        # The version of pax jumped 16 years in development between OS X 10.5
        # and OS X 10.6. In that time it became security conscious.
        safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"
      when 5664
        ohai "Installing gfortran 4.2.4 for XCode 3.2.3 (build 5664)"
        safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"
      when 5666
        ohai "Installing gfortran 4.2.4 for XCode 3.2.6--4.1 (build 5666)"
        safe_system "pax --insecure -rz -f Payload.gz -s ',./usr,#{prefix},'"
      else
        onoe <<-EOS.undent
          Currently the gfortran compiler provided by this brew is only supports
          the following versions of XCode:

            - XCode 3.1.4 on OS X 10.5.x
            - XCode 3.2.2/3.2.3 -- 4.0 on OS X 10.6.x
            - XCode 4.1 or newer on OS X 10.7.x

          The AppStore and Software Update can help upgrade your copy of XCode.
          The latest version of XCode is also available from:

              http://developer.apple.com/technologies/xcode.html
        EOS
        exit
      end
    end

    # Alias the manpage so it will be available via `man gfortran`
    safe_system "ln -sf #{man1}/gfortran-4.2.1 #{man1}/gfortran.1"
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

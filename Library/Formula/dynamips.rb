require 'formula'

class Dynamips < Formula
  homepage 'http://www.gns3.net/dynamips/'
  url 'http://sourceforge.net/projects/gns-3/files/Dynamips/0.2.8-RC3-community/dynamips-0.2.8-RC3-community.tar.gz'
  md5 '100d64f13eb383442a6a12a8bfa0c55c'

  depends_on 'libelf'

  def install
    # Install man pages to the standard Homebrew location
    inreplace 'Makefile' do |s|
      s.gsub! %r|\$\(DESTDIR\)/man|, man
    end

    # Figure out what hardware to build for
    case Hardware.cpu_type
    when :intel
      arch = 'x86'
      arch = 'amd64' if Hardware.is_64_bit?
    when :ppc
      arch = 'ppc32'
    else
      opoo 'Building with DYNAMIPS_ARCH=nojit - dynamips will be SLOW'
      arch = 'nojit'
    end

    ENV.j1
    system "make", "DYNAMIPS_CODE=stable", "DYNAMIPS_ARCH=#{arch}", "DESTDIR=#{prefix}", "install"
  end

  # There are no valid "test" methods for this executable. Running with --help
  # even returns 1 instead of 0.
  def test
    Kernel.system "dynamips --help"
    if ( $?.exitstatus == 1 || $?.exitstatus == 0 )
      return 0
    else
      return 1
    end
  end
end

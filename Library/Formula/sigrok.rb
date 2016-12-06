require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sigrok < Formula
  homepage 'http://sigrok.org'
  head 'git://sigrok.git.sourceforge.net/gitroot/sigrok/sigrok'

  depends_on 'pkg-config' => :build
  depends_on 'glib'    => :install
  depends_on 'libusb'  => :build
  depends_on 'libzip'  => :build
  depends_on 'libftdi' => :build
  depends_on 'python3' => :build
  skip_clean :all

  def install
    ENV['PKG_CONFIG_PATH'] += ":#{lib}/pkgconfig"
    for component in [ "libsigrok", "libsigrokdecode", "sigrok-cli" ] do
      cd component do
        system "./autogen.sh"
        system "./configure", "--prefix=#{prefix}"
        system "make install"
      end
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test sigrok`.
    system "false"
  end
end

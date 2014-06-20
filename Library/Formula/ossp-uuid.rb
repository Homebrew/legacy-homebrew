require 'formula'

class OsspUuid < Formula
  homepage 'http://www.ossp.org/pkg/lib/uuid/'
  url 'ftp://ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz'
  mirror 'https://gnome-build-stage-1.googlecode.com/files/uuid-1.6.2.tar.gz'
  sha1 '3e22126f0842073f4ea6a50b1f59dcb9d094719f'

  bottle do
    cellar :any
    revision 1
    sha1 'be005cdd4b3b2bb684a2c67458b241189fb234e2' => :mavericks
    sha1 'fbed4a708210f9c2fcf2ee70f8e82e4c92db3ac3' => :mountain_lion
    sha1 '853ec550d13e6cd48f2ff43605a6ae17b43f4565' => :lion
  end

  option :universal
  option "32-bit"

  # see https://github.com/Homebrew/homebrew/issues/16077
  keg_only "OS X provides a uuid.h which conflicts with ossp-uuid's header."

  def install
    if build.universal?
      ENV.universal_binary
    elsif build.build_32_bit?
      ENV.append 'CFLAGS', '-arch i386'
      ENV.append 'LDFLAGS', '-arch i386'
    end

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--without-perl",
                          "--without-php",
                          "--without-pgsql"
    system "make"
    system "make install"
  end
end

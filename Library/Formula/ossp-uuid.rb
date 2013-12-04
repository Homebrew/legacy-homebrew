require 'formula'

class OsspUuid < Formula
  homepage 'http://www.ossp.org/pkg/lib/uuid/'
  url 'ftp://ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz'
  bottle do
    cellar :any
    sha1 '95f106ffb112d84e5b1258f1518b311a564e6fe3' => :mavericks
    sha1 'ad991f9dc22bc7bc9fc51b43b8acba863ec48a88' => :mountain_lion
    sha1 '8b22c81d6d1947cf7858e5c56e07ec1ad484cec8' => :lion
  end

  mirror 'http://gnome-build-stage-1.googlecode.com/files/uuid-1.6.2.tar.gz'
  sha1 '3e22126f0842073f4ea6a50b1f59dcb9d094719f'

  option :universal
  option "32-bit"

  # see https://github.com/mxcl/homebrew/issues/16077
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

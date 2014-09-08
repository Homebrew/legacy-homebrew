require 'formula'

class Libusrsctp < Formula
  homepage 'http://sctp.fh-muenster.de/sctp-user-land-stack.html'
  url 'http://sctp.fh-muenster.de/download/libusrsctp-0.9.1.tar.gz'
  sha1 'b719ddd754fd21b2bda634db20640bb9477c2a1b'

  bottle do
    cellar :any
    sha1 "5a44c6618451a1a7958997a8f1c7781353c8a4c4" => :mavericks
    sha1 "455cdb36885107c097aaccc3da17bedfe6d83bf3" => :mountain_lion
    sha1 "a6675fb97024d0d59210cee40f7f6f94159dd3a6" => :lion
  end

  head do
    url 'http://sctp-refimpl.googlecode.com/svn/trunk/KERN/usrsctp'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system './bootstrap' if build.head?

    system './configure', '--disable-dependency-tracking',
                          "--prefix=#{prefix}"
    system 'make'
    system 'make install'
  end
end

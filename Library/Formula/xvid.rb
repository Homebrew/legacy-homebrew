require 'formula'

class Xvid < Formula
  homepage 'http://www.xvid.org'
  url 'http://fossies.org/unix/privat/xvidcore-1.3.2.tar.gz'
  # Official download takes a long time to fail, so set it as the mirror for now
  mirror 'http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz'
  sha1 '56e065d331545ade04c63c91153b9624b51d6e1b'

  bottle do
    cellar :any
    sha1 "744ecfcf206d6915261a0152f7c91276168d37de" => :mavericks
    sha1 "c76a75402e357334c34fbde45820759ebb141bc7" => :mountain_lion
    sha1 "d534eeeac7340e16195aac046104e9564fa8b11c" => :lion
  end

  def install
    cd 'build/generic' do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      ENV.j1 # Or make fails
      system "make"
      system "make install"
    end
  end
end

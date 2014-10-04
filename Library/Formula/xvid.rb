require 'formula'

class Xvid < Formula
  homepage 'http://www.xvid.org'
  url 'http://fossies.org/unix/privat/xvidcore-1.3.3.tar.gz'
  # Official download takes a long time to fail, so set it as the mirror for now
  mirror 'http://downloads.xvid.org/downloads/xvidcore-1.3.3.tar.gz'
  sha1 '465763c92679ca230526d4890d17dbf6d6974b08'

  bottle do
    cellar :any
    sha1 "193d4057a9efba3cffc00dd89a439199187ad44f" => :mavericks
    sha1 "85f9ef42226bf1e315afecf4ca51572bb0ab2cff" => :mountain_lion
    sha1 "23adf592abd0be309096c1b4d42ac106726c518d" => :lion
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

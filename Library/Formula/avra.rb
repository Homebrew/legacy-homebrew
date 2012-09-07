require 'formula'

class Avra < Formula
  homepage 'http://avra.sourceforge.net/'
  url 'http://sourceforge.net/projects/avra/files/1.3.0/avra-1.3.0.tar.bz2'
  sha1 '7ad7d168b02107d4f2d72951155798c2fd87d5a9'

  depends_on :automake

  def install
    # build fails if these don't exist
    touch 'NEWS'
    touch 'ChangeLog'
    cd "src" do
      system "./bootstrap"
      system "./configure", "--prefix=#{prefix}"
      system "make install"
    end
  end
end

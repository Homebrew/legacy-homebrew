require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.com/source/leptonica-1.70.tar.gz'
  sha1 '476edd5cc3f627f5ad988fcca6b62721188fce13'

  option 'check', 'Run the build checks'

  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :optional

  conflicts_with 'osxutils',
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check" if build.include? 'check'
    system "make install"
  end
end

require 'formula'

class Recoll < Formula
  homepage 'http://www.recoll.org'
  url 'http://www.recoll.org/recoll-1.19.7.tar.gz'
  sha1 'f7521966f5d128867cca0cfb73d999b87eed6a9f'

  depends_on 'xapian'
  depends_on 'qt'

  def patches
    { :p2 => [
        "https://bitbucket.org/medoc/recoll/commits/1e6e8586ee1f058f58fef5ebba5ae49d8267bee1/raw/",
      "https://bitbucket.org/medoc/recoll/commits/65a7041abbe6e64f6597d5cf27690e91014a85d4/raw/",
      "https://bitbucket.org/medoc/recoll/commits/79dcd7fa03797b6b51720025b3c3276395523c38/raw/"
    ]}
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/recollindex", "-h"
  end
end

require 'formula'

class Cracklib < Formula
  homepage 'http://cracklib.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cracklib/cracklib/2.9.0/cracklib-2.9.0.tar.gz'
  sha1 '827dcd24b14bf23911c34f4226b4453b24f949a3'

  bottle do
    sha1 "40df594cdc2483e6b68b75e019574dbe4fc10519" => :mavericks
    sha1 "f67cff17c3c71fc0f947b47da85e6eeb0a45a3b8" => :mountain_lion
    sha1 "c355b2de9ec2df8d647160d08236aef6a783c976" => :lion
  end

  depends_on "gettext"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-default-dict=#{HOMEBREW_PREFIX}/share/cracklib-words"
    system "make install"
  end
end

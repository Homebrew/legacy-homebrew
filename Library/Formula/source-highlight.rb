require 'formula'

class SourceHighlight < Formula
  homepage 'https://www.gnu.org/software/src-highlite/'
  url 'http://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.7.tar.gz'
  mirror 'https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.7.tar.gz'
  mirror 'http://mirror.anl.gov/pub/gnu/src-highlite/source-highlight-3.1.7.tar.gz'
  sha1 '71c637548be71afc3f895b0d8ada1a72a8dab4a0'

  bottle do
    sha1 "6bf1308730ead770b3ed8d47c2e93ec54d4058d8" => :yosemite
    sha1 "b9a4dce9a4342f562db11e933a3b859ffd06c5bc" => :mavericks
    sha1 "e8f5a3165b4e94056ea13c0ae2c93d6de8d78eed" => :mountain_lion
  end

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make install"

    bash_completion.install 'completion/source-highlight'
  end
end

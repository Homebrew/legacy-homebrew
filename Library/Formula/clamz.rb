require 'formula'

class Clamz < Formula
  homepage 'http://code.google.com/p/clamz/'
  url 'http://clamz.googlecode.com/files/clamz-0.5.tar.gz'
  sha1 '54664614e5098f9e4e9240086745b94fe638b176'

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "clamz"
  end

  def caveats; <<-EOS.undent
    After installing clamz, open one of the following links to enable
    the "MP3 downloader" mode in Amazon's web store:

    #{amazon_links}

    You can then proceed to purchase MP3 songs or albums. When you do so,
    you will be given a .amz file (a small, encrypted data file);
    run clamz on this file to download the actual MP3 music files.
    See the clamz manpage (man clamz) and README file for more information.
    EOS
  end

  private
    def amazon_links
      {
        'France' => 'fr',
        'Germany' => 'de',
        'Japan' => 'co.jp',
        'UK' => 'co.uk',
        'US' => 'com'
      }.map do |country, tld|
        "#{country}: http://www.amazon.#{tld}/gp/dmusic/after_download_manager_install.html?AMDVersion=1.0.9"
      end.join("\n    ")
    end
end

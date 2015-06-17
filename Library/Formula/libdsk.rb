require 'formula'

class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage 'http://www.seasip.info/Unix/LibDsk/'
  url 'http://www.seasip.info/Unix/LibDsk/libdsk-1.3.8.tar.gz'
  sha1 'eac675db4e16f35c86ba2d2f865c8e58a99156a7'

  bottle do
    sha256 "5b826726a3146916ec472d350c00656e878b0420d271b4c623d868fd91809637" => :yosemite
    sha256 "2992e58a9f040643f6c582057d72d4a8af67d18b0fca6ec605b8d06ecc7fb82b" => :mavericks
    sha256 "8b36ee07409e81ea6fe3fa72b43f7b8a025180ffbcf8eade58a48053330b3312" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (share+name+'doc').install Dir['doc/*.{html,txt,pdf}']
  end
end

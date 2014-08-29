require 'formula'

class Libsmi < Formula
  homepage 'http://www.ibr.cs.tu-bs.de/projects/libsmi/'
  url 'https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.4.8.tar.gz'
  sha1 '77c512ccbdd29667d152398b0dcde533aed57b49'

  bottle do
    sha1 "85840d6b3e66ecc3ff3c4044942a09cb4cd7bc12" => :mavericks
    sha1 "b59655ea31657172d78cfe736610ca510f788822" => :mountain_lion
    sha1 "7e2434d1b0ae815f91c98d09897d71d0a8197a46" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

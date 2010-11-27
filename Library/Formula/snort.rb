require 'formula'

class Snort <Formula
  url 'http://www.snort.org/dl/snort-current/snort-2.9.0.1.tar.gz'
  homepage ''
  md5 '30cc0094ba6365537185fb7eebea1491'
  depends_on 'pcre'
  depends_on 'libdnet'
  depends_on 'daq'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end

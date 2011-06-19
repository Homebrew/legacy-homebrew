require 'formula'

class BulkExtractor < Formula
  url 'http://afflib.org/downloads/bulk_extractor-0.7.24.tar.gz'
  homepage 'http://afflib.org/software/bulk_extractor'
  md5 '86c2681b0c938ba9eb0a630f0f66db1e'

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Install Python utilities
    (share+name+'python').install Dir['python/*.py']
  end

  def caveats; <<-EOS.undent
    You may need to add the directory containing the Python bindings to your PYTHONPATH:
      #{share+name}/python
    EOS
  end
end

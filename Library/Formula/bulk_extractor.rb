require 'formula'

class BulkExtractor < Formula
  url 'http://afflib.org/downloads/bulk_extractor-1.0.1.tar.gz'
  homepage 'http://afflib.org/software/bulk_extractor'
  md5 '8e19b2c4ae4cc1ab2e4fa17c96f4285c'

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Install documentation
    (share+name+'doc').install Dir['doc/*.{html,txt,pdf}']

    # Install Python utilities
    (share+name+'python').install Dir['python/*.py']
  end

  def caveats; <<-EOS.undent
    You may need to add the directory containing the Python bindings to your PYTHONPATH:
      #{share+name}/python
    EOS
  end
end

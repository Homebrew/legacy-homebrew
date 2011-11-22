require 'formula'

class BulkExtractor < Formula
  url 'http://afflib.org/downloads/bulk_extractor-1.1.0_beta8.tar.gz'
  version '1.1.0-beta8'
  homepage 'http://afflib.org/software/bulk_extractor'
  md5 '372d9e6642e68b28fceeac92cd7c33b4'

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

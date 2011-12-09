require 'formula'

class BulkExtractor < Formula
  url 'http://afflib.org/downloads/bulk_extractor-1.1.1.tar.gz'
  homepage 'http://afflib.org/software/bulk_extractor'
  md5 'ce95df931f63dedd6d0e5bd1a57288a7'

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

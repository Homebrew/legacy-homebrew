require 'formula'

class BulkExtractor < Formula
  homepage 'http://afflib.org/software/bulk_extractor'
  url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.2.0.tar.gz'
  md5 '95172e2a149681054b712890e8fdad57'

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

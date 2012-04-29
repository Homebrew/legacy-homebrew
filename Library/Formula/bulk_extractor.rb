require 'formula'

class BulkExtractor < Formula
  homepage 'http://afflib.org/software/bulk_extractor'
  url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.2.1.tar.gz'
  md5 '44f51d5a89b70cd4985cef2c57718801'

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional
  depends_on 'autoconf' if MacOS.xcode_version >= "4.3"
  depends_on 'automake' if MacOS.xcode_version >= "4.3"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
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

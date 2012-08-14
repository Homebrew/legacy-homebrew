require 'formula'

class BulkExtractor < Formula
  homepage 'https://github.com/simsong/bulk_extractor/wiki'
  url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.2.2.tar.gz'
  sha1 '2f0a2049259f826afe253cf5baeeb139b795dddb'

  devel do
    url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.3b5.tar.gz'
    sha1 '04a3d49f35efc7381ae1d3f516bdad273a0f49ee'
  end

  depends_on :autoconf
  depends_on :automake

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Install documentation
    (share/'bulk_extractor/doc').install Dir['doc/*.{html,txt,pdf}']

    # Install Python utilities
    (share/'bulk_extractor/python').install Dir['python/*.py']
  end

  def caveats; <<-EOS.undent
    You may need to add the directory containing the Python bindings to your PYTHONPATH:
      #{share}/bulk_extractor/python
    EOS
  end
end

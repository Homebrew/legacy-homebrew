require 'formula'

class BulkExtractor < Formula
  homepage 'http://afflib.org/software/bulk_extractor'
  url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.2.2.tar.gz'
  md5 '11ccee3709ac862a41edad309153c7a3'

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional
  depends_on 'autoconf' => :build if MacOS.xcode_version.to_f >= 4.3
  depends_on 'automake' => :build if MacOS.xcode_version.to_f >= 4.3

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

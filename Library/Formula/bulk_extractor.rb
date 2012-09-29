require 'formula'

class BulkExtractor < Formula
  homepage 'https://github.com/simsong/bulk_extractor/wiki'
  url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.2.2.tar.gz'
  sha1 '2f0a2049259f826afe253cf5baeeb139b795dddb'

  devel do
    url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.3b14.tar.gz'
    sha1 '0812b4ea6e0c1330cd720349ffcfe304355bf2c6'
  end

  depends_on :autoconf
  depends_on :automake

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional

  def patches
    # Error in exec install hooks; installing java GUI manually
    if build.devel?
      "https://gist.github.com/raw/3785687/f2bb51d0e2284d25b62271a4c068da42eedea31c/gistfile1.txt"
    end
  end

  def install
    system "bash", "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

    # Install documentation
    (share/'bulk_extractor/doc').install Dir['doc/*.{html,txt,pdf}']

    # Install Python utilities
    (share/'bulk_extractor/python').install Dir['python/*.py']

    # Install the GUI the Homebrew way
    libexec.install 'java_gui/BEViewer.jar'
    (bin+'BEViewer').write script
  end

  def script; <<-EOS.undent
    #!/bin/sh
    exec java -Xmx1g -jar #{libexec}/BEViewer.jar "$@"
    EOS
  end

  def caveats; <<-EOS.undent
    You may need to add the directory containing the Python bindings to your PYTHONPATH:
      #{share}/bulk_extractor/python
    EOS
  end
end

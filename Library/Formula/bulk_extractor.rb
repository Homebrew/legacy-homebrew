require 'formula'

class BulkExtractor < Formula
  homepage 'https://github.com/simsong/bulk_extractor/wiki'
  url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.3.tar.gz'
  sha1 '137a8a9c9d99f5f01eb09c080012b13ba48856ec'

  depends_on :autoconf
  depends_on :automake

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional

  def patches
    # Error in exec install hooks; installing java GUI manually. Reported in
    # https://groups.google.com/group/bulk_extractor-users/browse_thread/thread/ff7cc11e8e6d8e8d
    "https://gist.github.com/raw/3785687/20a2354930242db502169e1ea78499b40ec97239/gistfile1.txt"
  end

  def install
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

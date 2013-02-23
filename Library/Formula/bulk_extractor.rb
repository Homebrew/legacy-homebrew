require 'formula'

class BulkExtractor < Formula
  homepage 'https://github.com/simsong/bulk_extractor/wiki'
<<<<<<< HEAD
  url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.2.2.tar.gz'
  sha1 '2f0a2049259f826afe253cf5baeeb139b795dddb'

<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
  devel do
    url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.3b5.tar.gz'
    sha1 '04a3d49f35efc7381ae1d3f516bdad273a0f49ee'
  end
=======
  url 'https://github.com/downloads/simsong/bulk_extractor/bulk_extractor-1.3.1.tar.gz'
  sha1 'b4d68b0d08c1630b103875ec4c6524f46ad4a8ae'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

<<<<<<< HEAD
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
  depends_on :autoconf
  depends_on :automake

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional

  def patches
    # Error in exec install hooks; installing java GUI manually. Reported in
    # https://groups.google.com/group/bulk_extractor-users/browse_thread/thread/ff7cc11e8e6d8e8d
    "https://gist.github.com/raw/3785687/3a61d57539c2b9ecde44121b370db85ff9d4f86e/makefile.in.patch"
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
    bin.write_jar_script libexec/"BEViewer.jar", "BEViewer", "-Xmx1g"
  end

  def caveats; <<-EOS.undent
    You may need to add the directory containing the Python bindings to your PYTHONPATH:
      #{share}/bulk_extractor/python
    EOS
  end
end

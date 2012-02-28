require 'formula'

class Jam < Formula
  homepage 'http://www.perforce.com/jam/jam.html'
  url 'ftp://ftp.perforce.com/jam/jam-2.5.zip'
  md5 'f92caadb62fe4cb0b152eff508c9d450'

  def install
    # Why zip up as read-only?
    system "chmod a+w *"

    inreplace "Makefile" do |s|
      s.remove_make_var! ['CC', 'CFLAGS']
    end

    system "make"
    bin.install "bin.macosx/jam", "bin.macosx/mkjambase"
  end
end

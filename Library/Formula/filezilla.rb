require 'formula'

# FileZilla FTP client.
# See: http://wiki.filezilla-project.org/Compiling_FileZilla_3_under_Mac_OS_X

class Filezilla <Formula
  url 'http://d10xg45o6p6dbl.cloudfront.net/projects/f/filezilla/FileZilla_3.3.0.1_src.tar.bz2'
  homepage 'http://filezilla-project.org/'
  md5 'f273aef3b8408d0a1c7f0fee39733e9b'
  
  depends_on 'pkg-config'
  depends_on 'libidn'
  depends_on 'gnutls'
  depends_on 'gettext'

  # depends on wxWidgets >= 2.8.9; 10.5 has 2.8.4, 10.6 has 2.8.8
  depends_on 'wxmac'

  def install
    # --disable-locales because msgfmt complains about "filezilla.pot" not
    # being there (even though it certainly looks like it's there to me.)

    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-locales"
    
    system "make"
    
    # Install the .app
    Dir.chdir "FileZilla.app/Contents/MacOS" do
      system "strip filezilla fzputtygen fzsftp"
    end
    
    prefix.install "FileZilla.app"
  end
  
  def caveats
    "FileZilla.app installed to #{prefix}."
  end
end

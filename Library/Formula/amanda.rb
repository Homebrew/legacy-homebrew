require 'formula'

class Amanda < Formula
  url 'http://downloads.sourceforge.net/project/amanda/amanda%20-%20stable/3.3.0/amanda-3.3.0.tar.gz?r=&ts=1317090207&use_mirror=voxel'
  homepage 'http://www.amanda.org/'
  md5 'e206f42fb523c6bfe728b03665d4e277'
  version '3.3.0'

  depends_on 'glib'
  depends_on 'gnu-tar'

  ENV['ARCHFLAGS'] = "-arch i386"

  def install
    user = ENV['USER']
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-user=#{user}", "--with-group=admin",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make"
    system "sudo make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test amanda`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end

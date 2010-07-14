require 'formula'

class Avanor <Formula
  url 'http://downloads.sourceforge.net/project/avanor/avanor/0.5.8/avanor-0.5.8-src.tar.bz2'
  homepage 'http://avanor.sourceforge.net/'
  md5 '20067962b9635b1789933ddd7933d142'

  def install
    inreplace 'Makefile' do |contents|
      contents.gsub! "CC = gpp", "CC = cpp"
      contents.gsub! "LD = gpp", "LD = cpp"
      contents.gsub! "$(DATA_DIR)", (share+"avanor")
    end

    system "make"
    bin.install "avanor"
    (share+"avanor").install "manual"
  end
end

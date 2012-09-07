require 'formula'

class Fiwalk < Formula
  homepage 'http://afflib.org/software/fiwalk'
  url 'https://github.com/downloads/kfairbanks/sleuthkit/fiwalk-0.6.16.tar.gz'
  sha1 '36ba2e97a201cd240fc7187185f07a5c56ee1982'

  depends_on 'sleuthkit'
  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (share+name).mkpath

    cd 'plugins' do
      # For some reason make install does not create the Java plugins JAR file even though it
      # builds other things in the plugins directory.
      system "make plugins.jar"
      libexec.install 'plugins.jar' => 'fiwalk-plugins.jar'

      # Install Python script-based plugins.
      bin.install Dir['*.py']

      # Fix paths in fiwalk's config file
      inreplace 'ficonfig.txt' do |s|
        s.gsub! 'dgi	../plugins/jpeg_extract', "dgi	#{prefix}/jpeg_extract"
        s.gsub! '../plugins/plugins.jar', "#{libexec}/fiwalk-plugins.jar"
      end
      (share+name).install 'ficonfig.txt'
    end

    # Install Python bindings and extra scripts.
    (share+name+'python').install Dir['python/*.py']
  end

  def caveats; <<-EOS.undent
    fiwalk's config file is located at:
      #{share+name}/ficonfig.txt

    You may need to add the directory containing the Python bindings to your PYTHONPATH:
      #{share+name}/python
    EOS
  end
end

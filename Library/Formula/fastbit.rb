class Fastbit < Formula
  homepage "https://sdm.lbl.gov/fastbit/"
  url "https://codeforge.lbl.gov/frs/download.php/416/fastbit-2.0.2.tar.gz"
  sha256 "a9d6254fcc32da6b91bf00285c7820869950bed25d74c993da49e1336fd381b4"

  head "https://codeforge.lbl.gov/anonscm/fastbit/trunk",
       :using => :svn

  conflicts_with "iniparser",
                 :because => "Both install `include/dictionary.h`"

  depends_on :java
  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    libexec.install lib/"fastbitjni.jar"
    bin.write_jar_script libexec/"fastbitjni.jar", "fastbitjni"
  end

  test do
    assert_equal prefix.to_s,
                 shell_output("#{bin}/fastbit-config --prefix").chomp
    (testpath/"test.csv").write <<-EOS
      Potter,Harry
      Granger,Hermione
      Weasley,Ron
     EOS
    system bin/"ardea", "-d", testpath,
           "-m", "a:t,b:t", "-t", testpath/"test.csv"
  end
end
